// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/models/shape.dart';
import '../../../domain/models/shape_kind.dart';
import '../../../domain/models/tool.dart';
import '../../../domain/services/geometry_utils.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';
import 'editor_ops.dart';

/// The drawing tools: rectangle, ellipse, line and freehand are drag-driven,
/// polygon is click-driven.
abstract class DrawLogic {
  DrawLogic._();

  static Shape newShape(EditorState s, ShapeKind kind, List<Offset> points) {
    final open = kind == ShapeKind.line || kind == ShapeKind.freehand;
    final count = s.drawing.layers.fold<int>(0, (n, l) => n + l.shapes.length);
    final st = s.style;
    return Shape(
      kind: kind,
      points: points,
      name: '${kind.name[0].toUpperCase()}${kind.name.substring(1)} ${count + 1}',
      fill: open || !st.fillOn ? null : st.fillColor,
      gradient: open || !st.fillOn ? null : st.fillGradient,
      stroke: (st.strokeOn || open) ? st.strokeColor : null,
      strokeWidth: st.strokeWidth,
      radius: kind == ShapeKind.rect ? st.radius : 0,
    );
  }

  static EditorState pressed(EditorState s, Offset p, int timeMs) {
    final snapped = s.snapped(p);
    switch (s.tool) {
      case Tool.rect:
        return _begin(s, ShapeKind.rect, snapped);
      case Tool.ellipse:
        return _begin(s, ShapeKind.ellipse, snapped);
      case Tool.line:
        return _begin(s, ShapeKind.line, snapped);
      case Tool.freehand:
        return _begin(s, ShapeKind.freehand, p);
      case Tool.polygon:
        return _polygonClick(s, snapped, timeMs);
      case Tool.select:
      case Tool.reference:
        return s;
    }
  }

  static EditorState _begin(EditorState s, ShapeKind kind, Offset p) {
    final points = kind == ShapeKind.freehand ? [p] : [p, p];
    return s.copyWith(
      draft: newShape(s, kind, points),
      gesture: s.gesture.copyWith(mode: GestureMode.draw, origin: p),
    );
  }

  static EditorState moved(EditorState s, Offset p, bool shift) {
    final d = s.draft;
    if (s.gesture.mode != GestureMode.draw || d == null) return s;
    if (d.kind == ShapeKind.freehand) {
      if ((p - d.points.last).distance * s.view.zoom <= 3) return s;
      return s.copyWith(draft: d.copyWith(points: [...d.points, p]));
    }
    var q = s.snapped(p);
    if (shift) q = constrainDrag(d.kind, s.gesture.origin, q);
    return s.copyWith(draft: d.copyWith(points: [d.points.first, q]));
  }

  static EditorState released(EditorState s) {
    final d = s.draft;
    final idle = s.endGesture();
    if (d == null) return idle;
    return isWorthKeeping(d) ? commitDraft(idle) : cancelDraft(idle);
  }

  /// Rubber-band line from the last polygon point to the cursor.
  static EditorState hovered(EditorState s, Offset p) =>
      s.draft != null && s.tool == Tool.polygon
          ? s.copyWith(hover: s.snapped(p))
          : s;

  /// Each click adds a point. A click near the first point, or a double-click,
  /// closes the polygon; Enter (PolygonFinished) leaves it open.
  static EditorState _polygonClick(EditorState s, Offset p, int timeMs) {
    final doubleClick = timeMs - s.gesture.lastClickMs < 320;
    final base = s.copyWith(gesture: s.gesture.copyWith(lastClickMs: timeMs));
    final d = base.draft;
    if (d == null) {
      return base.copyWith(draft: newShape(base, ShapeKind.polygon, [p]), hover: p);
    }
    final onFirst =
        d.points.length >= 3 && (d.points.first - p).distance < 8 / base.view.zoom;
    if (onFirst || doubleClick) return finishPolygon(base);
    return base.copyWith(draft: d.copyWith(points: [...d.points, p]));
  }

  /// Ends the polygon tool's click sequence. [closed] makes a filled polygon
  /// (needs 3+ points); otherwise, or with too few points, it becomes an open
  /// line path.
  static EditorState finishPolygon(EditorState s, {bool closed = true}) {
    final d = s.draft;
    if (d == null) return s;
    if (closed && d.points.length >= 3) return commitDraft(s);
    if (d.points.length >= 2) {
      return commitDraft(s.copyWith(
        draft: d.copyWith(
          kind: ShapeKind.line,
          fill: null,
          stroke: d.stroke ?? s.style.strokeColor,
        ),
      ));
    }
    return cancelDraft(s);
  }

  static EditorState commitDraft(EditorState s) {
    final d = s.draft;
    if (d == null) return s;
    final layer = s.layer.copyWith(visible: true, shapes: [...s.layer.shapes, d]);
    return s
        .withLayers(replacedAt(s.drawing.layers, s.layerIndex, layer))
        .copyWith(draft: null, hover: null, selected: null)
        .endGesture()
        .commit();
  }

  static EditorState cancelDraft(EditorState s) =>
      s.copyWith(draft: null, hover: null).endGesture();
}
