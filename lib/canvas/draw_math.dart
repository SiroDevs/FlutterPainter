// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../model/shape.dart';

/// Rounds [p] to the snap grid: whole units, or half units when zoomed in far.
Offset snapPoint(Offset p, {required bool enabled, required double zoom}) {
  if (!enabled) return p;
  final step = zoom >= 20 ? 0.5 : 1.0;
  return Offset((p.dx / step).roundToDouble() * step,
      (p.dy / step).roundToDouble() * step);
}

/// Shift-drag: squares and circles for boxes, 45° steps for lines.
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
