// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/services/geometry/geometry_utils.dart';
import '../../../../domain/services/geometry/shape_geometry.dart';
import '../../bloc/editor_bloc.dart';
import '../../models/gesture_state.dart';
import '../drawing/editor_ops.dart';
import '../canvas/image_logic.dart';
import 'selection_transform_logic.dart';
import '../drawing/style_logic.dart';
import '../drawing/vertex_logic.dart';

/// Selection, marquee, move, resize, rotate, and vertex editing.
abstract class SelectLogic {
  SelectLogic._();

  static EditorState pressed(
    EditorState state,
    Offset point, {
    required bool alt,
    required bool shift,
    required int timeMs,
  }) {
    final doubleClick = timeMs - state.gesture.lastClickMs < 320;
    final base = state.copyWith(gesture: state.gesture.copyWith(lastClickMs: timeMs));
    final shape = base.selectedShape;
    final bounds = base.selectedBounds;

    if (bounds != null && base.validSelectedIndices.isNotEmpty) {
      final rotateHandle = SelectionTransformLogic.rotationHandle(
        bounds,
        base.view.zoom,
      );
      if ((rotateHandle - point).distance <= 9 / base.view.zoom) {
        final indices = base.validSelectedIndices;
        return base.copyWith(
          gesture: base.gesture.copyWith(
            mode: GestureMode.rotate,
            origin: point,
            startBounds: bounds,
            startIndices: indices,
            startShapes: [for (final i in indices) base.layer.shapes[i]],
          ),
        );
      }
    }

    if (bounds != null && base.validSelectedIndices.length > 1) {
      final indices = base.validSelectedIndices;
      final handle = hitBoundsHandle(bounds, point, 8 / base.view.zoom);
      if (handle != null) {
        return base.copyWith(
          gesture: base.gesture.copyWith(
            mode: GestureMode.scale,
            handle: handle,
            origin: point,
            startBounds: bounds,
            startIndices: indices,
            startShapes: [for (final index in indices) base.layer.shapes[index]],
          ),
        );
      }
    }

    if (shape != null && base.validSelectedIndices.length == 1) {
      final handle = hitHandle(shape, point, 8 / base.view.zoom);
      if (handle != null) {
        if (shape.usesVertices && alt) return VertexLogic.remove(base, handle);
        return base.copyWith(
          gesture: base.gesture.copyWith(
            mode: shape.usesVertices ? GestureMode.vertex : GestureMode.scale,
            handle: handle,
            origin: point,
            startPoints: shape.points,
            startBounds: shape.unrotatedBounds,
          ),
        );
      }
      if (doubleClick && shape.usesVertices) {
        final inserted = VertexLogic.insert(base, point, 6 / base.view.zoom);
        if (inserted != null) return inserted;
      }
    }

    if (base.imageSelected) {
      final box = base.imageBounds;
      if (box != null && ImageLogic.handleAt(base, point) != null) {
        return ImageLogic.grab(base, point, box);
      }
    }

    if (shift) {
      final hit = _hitInActiveLayer(base, point);
      if (hit != null) return _toggle(base, hit);
      return _startMarquee(base, point, additive: true);
    }
    return _pick(base, point);
  }

  static EditorState _startMarquee(
    EditorState state,
    Offset point, {
    required bool additive,
  }) {
    final oldSelection = additive ? state.validSelectedIndices : const <int>[];
    final next = additive ? state : state.selectIndices(const []);
    return next.copyWith(
      gesture: next.gesture.copyWith(
        mode: GestureMode.marquee,
        origin: point,
        startBounds: Rect.fromPoints(point, point),
        selectionAtStart: oldSelection,
        additiveSelection: additive,
      ),
    );
  }

  /// Selects topmost shape or picture and starts moving it. A grouped shape
  /// selects all its peers in the active layer.
  static EditorState _pick(EditorState state, Offset point) {
    final tol = 4 / state.view.zoom;
    final layers = state.drawing.layers;
    for (var li = layers.length - 1; li >= 0; li--) {
      final layer = layers[li];
      if (!layer.visible) continue;
      for (var si = layer.shapes.length - 1; si >= 0; si--) {
        final shape = layer.shapes[si];
        if (!shape.hitTest(point, tol)) continue;
        final switchedLayer = li != state.layerIndex;
        final base = switchedLayer
            ? state.copyWith(
                layerIndex: li,
                selected: null,
                selectedIndices: const [],
              )
            : state;
        final selected = base.validSelectedIndices.contains(si)
            ? base
            : base.selectIndices(
                groupedShapeIndices(layer.shapes, si),
                primary: si,
              );
        final indices = selected.validSelectedIndices;
        return selected.copyWith(
          style: StyleLogic.adopt(selected.style, shape),
          gesture: selected.gesture.copyWith(
            mode: GestureMode.move,
            origin: point,
            startIndices: indices,
            startShapes: [for (final i in indices) selected.layer.shapes[i]],
          ),
        );
      }
      final reference = layer.image;
      final pixels = reference == null ? null : state.images[reference.id];
      if (reference != null && reference.visible && pixels != null) {
        final box = Rect.fromLTWH(
          reference.x,
          reference.y,
          pixels.width * reference.scaleX,
          pixels.height * reference.scaleY,
        );
        if (box.contains(point)) {
          return state.copyWith(
            layerIndex: li,
            selected: kImageSlot,
            selectedIndices: const [],
            gesture: state.gesture.copyWith(
              mode: GestureMode.imageMove,
              handle: -1,
              origin: point,
              startBounds: box,
            ),
          );
        }
      }
    }
    return _startMarquee(state, point, additive: false);
  }

  static int? _hitInActiveLayer(EditorState state, Offset point) {
    if (!state.layer.visible) return null;
    final shapes = state.layer.shapes;
    final tol = 4 / state.view.zoom;
    for (var i = shapes.length - 1; i >= 0; i--) {
      if (shapes[i].hitTest(point, tol)) return i;
    }
    return null;
  }

  static EditorState _toggle(EditorState state, int index) {
    final toggled = groupedShapeIndices(state.layer.shapes, index).toSet();
    final old = state.validSelectedIndices.toSet();
    final next = old.contains(index)
        ? old.difference(toggled)
        : old.union(toggled);
    return state.selectIndices(
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
