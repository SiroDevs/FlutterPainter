// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../models/shape.dart';
import '../models/shape_kind.dart';

/// Rounds [p] to the snap grid: whole units, or half units when zoomed in far.
Offset snapPoint(Offset p, {required bool enabled, required double zoom}) {
  if (!enabled) return p;
  final step = zoom >= 20 ? 0.5 : 1.0;
  return Offset((p.dx / step).roundToDouble() * step,
      (p.dy / step).roundToDouble() * step);
}

/// Shift-drag: squares and circles for boxes, 45 degree steps for lines.
Offset constrainDrag(ShapeKind kind, Offset origin, Offset q) {
  final dx = q.dx - origin.dx;
  final dy = q.dy - origin.dy;
  if (kind == ShapeKind.line) {
    const step = math.pi / 4;
    final angle = (math.atan2(dy, dx) / step).round() * step;
    return origin + Offset(math.cos(angle), math.sin(angle)) * (q - origin).distance;
  }
  final m = math.max(dx.abs(), dy.abs());
  return Offset(origin.dx + (dx < 0 ? -m : m), origin.dy + (dy < 0 ? -m : m));
}

/// The box after dragging corner [handle] (0 TL, 1 TR, 2 BR, 3 BL) of [start]
/// to [to]. The opposite corner stays put.
Rect resizedBox(Rect start, int handle, Offset to) {
  final corners = [start.topLeft, start.topRight, start.bottomRight, start.bottomLeft];
  return Rect.fromPoints(corners[(handle + 2) % 4], to);
}

/// Maps [pts] from the box [from] into the box [to] (used for resizing).
List<Offset> remapPoints(List<Offset> pts, Rect from, Rect to) {
  final sx = from.width == 0 ? 1.0 : to.width / from.width;
  final sy = from.height == 0 ? 1.0 : to.height / from.height;
  return [
    for (final p in pts)
      Offset(to.left + (p.dx - from.left) * sx, to.top + (p.dy - from.top) * sy),
  ];
}

/// Whether a just-drawn draft is big enough to keep (stray clicks are dropped).
bool isWorthKeeping(Shape d) {
  switch (d.kind) {
    case ShapeKind.freehand:
      return d.points.length > 1;
    case ShapeKind.line:
      return (d.points[1] - d.points[0]).distance >= 0.5;
    default:
      return d.bounds.width >= 0.5 && d.bounds.height >= 0.5;
  }
}

/// Where a selected shape's grab handles sit: its vertices for lines and
/// polygons, otherwise the four corners of its box (TL, TR, BR, BL).
List<Offset> handlePoints(Shape s) {
  if (s.usesVertices) return s.points;
  final b = s.bounds;
  return [b.topLeft, b.topRight, b.bottomRight, b.bottomLeft];
}

/// Index of the handle within [tol] of [p], or null.
int? hitHandle(Shape s, Offset p, double tol) {
  final pts = handlePoints(s);
  for (var i = 0; i < pts.length; i++) {
    if ((pts[i] - p).distance <= tol) return i;
  }
  return null;
}
