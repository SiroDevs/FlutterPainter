// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/services/geometry_utils.dart';
import '../../../domain/services/shape_geometry.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';
import 'editor_ops.dart';
import 'style_logic.dart';
import 'vertex_logic.dart';

/// The Select tool: pick, move, resize by corner handles, drag vertices,
/// double-click an edge to add a point, Alt-click a point to delete it.
abstract class SelectLogic {
  SelectLogic._();

  static EditorState pressed(
    EditorState s,
    Offset p, {
    required bool alt,
    required int timeMs,
  }) {
    final doubleClick = timeMs - s.gesture.lastClickMs < 320;
    final base = s.copyWith(gesture: s.gesture.copyWith(lastClickMs: timeMs));
    final shape = base.selectedShape;
    if (shape != null) {
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
    return _pick(base, p);
  }

  /// Selects the topmost visible shape under [p] and starts moving it.
  static EditorState _pick(EditorState s, Offset p) {
    final tol = 4 / s.view.zoom;
    final layers = s.drawing.layers;
    for (var li = layers.length - 1; li >= 0; li--) {
      final layer = layers[li];
      if (!layer.visible) continue;
      for (var si = layer.shapes.length - 1; si >= 0; si--) {
        final shape = layer.shapes[si];
        if (!shape.hitTest(p, tol)) continue;
        return s.copyWith(
          layerIndex: li,
          selected: si,
          style: StyleLogic.adopt(s.style, shape),
          gesture: s.gesture.copyWith(
            mode: GestureMode.move,
            origin: p,
            startPoints: shape.points,
            startBounds: shape.bounds,
          ),
        );
      }
    }
    return s.copyWith(selected: null);
  }

  static EditorState moved(EditorState s, Offset p) {
    final shape = s.selectedShape;
    final g = s.gesture;
    if (shape == null) return s;
    switch (g.mode) {
      case GestureMode.move:
        var delta = p - g.origin;
        if (s.view.snap) delta = s.snapped(delta);
        return s.withSelectedShape(
          shape.copyWith(points: [for (final q in g.startPoints) q + delta]),
        );
      case GestureMode.scale:
        final to = resizedBox(g.startBounds, g.handle, s.snapped(p));
        if (to.width < 0.5 || to.height < 0.5) return s;
        return s.withSelectedShape(
          shape.copyWith(points: remapPoints(g.startPoints, g.startBounds, to)),
        );
      case GestureMode.vertex:
        return s.withSelectedShape(
          shape.copyWith(points: replacedAt(shape.points, g.handle, s.snapped(p))),
        );
      case GestureMode.none:
      case GestureMode.draw:
      case GestureMode.referenceDrag:
        return s;
    }
  }

  static EditorState released(EditorState s) => s.endGesture().commit();
}
