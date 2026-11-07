// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../domain/services/geometry_utils.dart';
import '../../../domain/services/shape_geometry.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';
import 'exports.dart';

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
      final rotateHandle = rotationHandle(bounds, base.view.zoom);
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
            startBounds: shape.bounds,
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

  static EditorState _startMarquee(EditorState s, Offset p, {required bool additive}) {
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
            ? s.copyWith(layerIndex: li, selected: null, selectedIndices: const [])
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
    return [for (var i = 0; i < shapes.length; i++) if (shapes[i].groupId == id) i];
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
    final next = old.contains(index) ? old.difference(toggled) : old.union(toggled);
    return s.selectIndices(next.toList(), primary: next.contains(index) ? index : null);
  }

  static EditorState moved(EditorState s, Offset p, {required bool shift}) {
    final g = s.gesture;
    final shape = s.selectedShape;
    switch (g.mode) {
      case GestureMode.move:
        if (g.startIndices.isEmpty) return s;
        var delta = p - g.origin;
        if (s.view.snap) delta = s.snapped(delta);
        final changes = <int, Shape>{};
        for (var i = 0; i < g.startIndices.length; i++) {
          final original = g.startShapes[i];
          changes[g.startIndices[i]] = original.copyWith(
            points: [for (final q in original.points) q + delta],
          );
        }
        return s.withShapeChanges(changes);
      case GestureMode.scale:
        if (shape == null) return s;
        final to = resizedBox(g.startBounds, g.handle, s.snapped(p));
        if (to.width < 0.5 || to.height < 0.5) return s;
        return s.withSelectedShape(
          shape.copyWith(points: remapPoints(g.startPoints, g.startBounds, to)),
        );
      case GestureMode.rotate:
        if (g.startShapes.isEmpty) return s;
        final pivot = g.startBounds.center;
        final from = g.origin - pivot;
        final to = p - pivot;
        if (from.distance < 0.001 || to.distance < 0.001) return s;
        var angle = math.atan2(to.dy, to.dx) - math.atan2(from.dy, from.dx);
        if (shift) {
          const increment = math.pi / 12;
          angle = (angle / increment).round() * increment;
        }
        final cosA = math.cos(angle);
        final sinA = math.sin(angle);
        final changes = <int, Shape>{};
        for (var i = 0; i < g.startIndices.length; i++) {
          final original = g.startShapes[i];
          changes[g.startIndices[i]] = original.copyWith(points: [
            for (final point in original.points)
              Offset(
                pivot.dx + (point.dx - pivot.dx) * cosA - (point.dy - pivot.dy) * sinA,
                pivot.dy + (point.dx - pivot.dx) * sinA + (point.dy - pivot.dy) * cosA,
              ),
          ]);
        }
        return s.withShapeChanges(changes);
      case GestureMode.vertex:
        if (shape == null) return s;
        return s.withSelectedShape(
          shape.copyWith(points: replacedAt(shape.points, g.handle, s.snapped(p))),
        );
      case GestureMode.marquee:
        return s.copyWith(
          gesture: g.copyWith(startBounds: Rect.fromPoints(g.origin, p)),
        );
      case GestureMode.none:
      case GestureMode.draw:
      case GestureMode.imageMove:
      case GestureMode.imageScale:
        return s;
    }
  }

  static EditorState released(EditorState s) {
    final g = s.gesture;
    if (g.mode == GestureMode.marquee) {
      final area = g.startBounds;
      final hits = <int>{
        if (area.width >= 2 / s.view.zoom || area.height >= 2 / s.view.zoom)
          for (var i = 0; i < s.layer.shapes.length; i++)
            if (s.layer.shapes[i].bounds.overlaps(area) || area.contains(s.layer.shapes[i].bounds.center)) i,
      };
      for (final i in [...hits]) {
        final id = s.layer.shapes[i].groupId;
        if (id != null) {
          for (var j = 0; j < s.layer.shapes.length; j++) {
            if (s.layer.shapes[j].groupId == id) hits.add(j);
          }
        }
      }
      if (g.additiveSelection) hits.addAll(g.selectionAtStart);
      return s.selectIndices(hits.toList()).endGesture();
    }
    return s.endGesture().commit();
  }

  /// The circular rotation handle sits above the center of the selection box.
  static Offset rotationHandle(Rect bounds, double zoom) =>
      Offset(bounds.center.dx, bounds.top - 22 / zoom);
}
