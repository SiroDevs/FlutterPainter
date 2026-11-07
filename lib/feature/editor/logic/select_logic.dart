// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/models/shape.dart';
import '../../../domain/services/geometry_utils.dart';
import '../../../domain/services/shape_geometry.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';
import 'editor_ops.dart';
import 'image_logic.dart';
import 'selection_transform_logic.dart';
import 'style_logic.dart';
import 'vertex_logic.dart';

/// Selection, marquee, move, resize, rotate, and vertex editing.
abstract class SelectLogic {
  SelectLogic._();

  static EditorState pressed(
    EditorState s,
    Offset p, {
    required bool alt,
    required bool shift,
    required int timeMs,
  }) {
    final doubleClick = timeMs - s.gesture.lastClickMs < 320;
    final base = s.copyWith(gesture: s.gesture.copyWith(lastClickMs: timeMs));
    final shape = base.selectedShape;
    final bounds = base.selectedBounds;

    if (bounds != null && base.validSelectedIndices.isNotEmpty) {
      final rotateHandle = SelectionTransformLogic.rotationHandle(
        bounds,
        base.view.zoom,
      );
      if ((rotateHandle - p).distance <= 9 / base.view.zoom) {
        final indices = base.validSelectedIndices;
        return base.copyWith(
          gesture: base.gesture.copyWith(
            mode: GestureMode.rotate,
            origin: p,
            startBounds: bounds,
            startIndices: indices,
            startShapes: [for (final i in indices) base.layer.shapes[i]],
          ),
        );
      }
    }

    if (shape != null && base.validSelectedIndices.length == 1) {
      final handle = hitHandle(shape, p, 8 / base.view.zoom);
      if (handle != null) {
        if (shape.usesVertices && alt) return VertexLogic.remove(base, handle);
        return base.copyWith(
          gesture: base.gesture.copyWith(
            mode: shape.usesVertices ? GestureMode.vertex : GestureMode.scale,
            handle: handle,
            origin: p,
            startPoints: shape.points,
            startBounds: shape.unrotatedBounds,
          ),
        );
      }
      if (doubleClick && shape.usesVertices) {
        final inserted = VertexLogic.insert(base, p, 6 / base.view.zoom);
        if (inserted != null) return inserted;
      }
    }

    if (base.imageSelected) {
      final box = base.imageBounds;
      if (box != null && ImageLogic.handleAt(base, p) != null) {
        return ImageLogic.grab(base, p, box);
      }
    }

    if (shift) {
      final hit = _hitInActiveLayer(base, p);
      if (hit != null) return _toggle(base, hit);
      return _startMarquee(base, p, additive: true);
    }
    return _pick(base, p);
  }

  static EditorState _startMarquee(
    EditorState s,
    Offset p, {
    required bool additive,
  }) {
    final oldSelection = additive ? s.validSelectedIndices : const <int>[];
    final next = additive ? s : s.selectIndices(const []);
    return next.copyWith(
      gesture: next.gesture.copyWith(
        mode: GestureMode.marquee,
        origin: p,
        startBounds: Rect.fromPoints(p, p),
        selectionAtStart: oldSelection,
        additiveSelection: additive,
      ),
    );
  }

  /// Selects topmost shape or picture and starts moving it. A grouped shape
  /// selects all its peers in the active layer.
  static EditorState _pick(EditorState s, Offset p) {
    final tol = 4 / s.view.zoom;
    final layers = s.drawing.layers;
    for (var li = layers.length - 1; li >= 0; li--) {
      final layer = layers[li];
      if (!layer.visible) continue;
      for (var si = layer.shapes.length - 1; si >= 0; si--) {
        final shape = layer.shapes[si];
        if (!shape.hitTest(p, tol)) continue;
        final switchedLayer = li != s.layerIndex;
        final base = switchedLayer
            ? s.copyWith(
                layerIndex: li,
                selected: null,
                selectedIndices: const [],
              )
            : s;
        final selected = base.validSelectedIndices.contains(si)
            ? base
            : base.selectIndices(_groupIndices(layer.shapes, si), primary: si);
        final indices = selected.validSelectedIndices;
        return selected.copyWith(
          style: StyleLogic.adopt(selected.style, shape),
          gesture: selected.gesture.copyWith(
            mode: GestureMode.move,
            origin: p,
            startIndices: indices,
            startShapes: [for (final i in indices) selected.layer.shapes[i]],
          ),
        );
      }
      final r = layer.image;
      final pixels = r == null ? null : s.images[r.id];
      if (r != null && r.visible && pixels != null) {
        final box = Rect.fromLTWH(
          r.x,
          r.y,
          pixels.width * r.scaleX,
          pixels.height * r.scaleY,
        );
        if (box.contains(p)) {
          return s.copyWith(
            layerIndex: li,
            selected: kImageSlot,
            selectedIndices: const [],
            gesture: s.gesture.copyWith(
              mode: GestureMode.imageMove,
              handle: -1,
              origin: p,
              startBounds: box,
            ),
          );
        }
      }
    }
    return _startMarquee(s, p, additive: false);
  }

  static List<int> _groupIndices(List<Shape> shapes, int index) {
    final id = shapes[index].groupId;
    if (id == null) return [index];
    return [
      for (var i = 0; i < shapes.length; i++)
        if (shapes[i].groupId == id) i,
    ];
  }

  static int? _hitInActiveLayer(EditorState s, Offset p) {
    final shapes = s.layer.shapes;
    final tol = 4 / s.view.zoom;
    for (var i = shapes.length - 1; i >= 0; i--) {
      if (shapes[i].hitTest(p, tol)) return i;
    }
    return null;
  }

  static EditorState _toggle(EditorState s, int index) {
    final toggled = _groupIndices(s.layer.shapes, index).toSet();
    final old = s.validSelectedIndices.toSet();
    final next = old.contains(index)
        ? old.difference(toggled)
        : old.union(toggled);
    return s.selectIndices(
      next.toList(),
      primary: next.contains(index) ? index : null,
    );
  }

  static EditorState moved(
    EditorState state,
    Offset point, {
    required bool shift,
  }) => SelectionTransformLogic.moved(state, point, shift: shift);

  static EditorState released(EditorState state) =>
      SelectionTransformLogic.released(state);
}
