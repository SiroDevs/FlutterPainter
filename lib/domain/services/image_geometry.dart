// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

/// Handles on a picture's box. 0-3 are the corners (top-left, top-right,
/// bottom-right, bottom-left), 4-7 the edge midpoints (top, right, bottom, left).
const int imageCornerCount = 4;
const int imageHandleCount = 8;

List<Offset> imageHandlePoints(Rect r) => [
      r.topLeft,
      r.topRight,
      r.bottomRight,
      r.bottomLeft,
      r.topCenter,
      r.centerRight,
      r.bottomCenter,
      r.centerLeft,
    ];

/// The handle under [p], corners first, or null.
int? hitImageHandle(Rect r, Offset p, double tol) {
  final pts = imageHandlePoints(r);
  for (var i = 0; i < pts.length; i++) {
    if ((pts[i] - p).distance <= tol) return i;
  }
  return null;
}

/// The box after dragging [handle] of [start] to [p].
///
/// A corner keeps the picture's proportions when [keepAspect] is set and
/// stretches both sides freely otherwise. An edge handle always moves just that
/// one side, which stretches the picture along one axis. Dragging past the
/// opposite side flips the box rather than inverting it.
Rect resizeImageRect(
  Rect start,
  int handle,
  Offset p, {
  bool keepAspect = false,
}) {
  switch (handle) {
    case 0:
    case 1:
    case 2:
    case 3:
      final corners = [
        start.topLeft,
        start.topRight,
        start.bottomRight,
        start.bottomLeft,
      ];
      final anchor = corners[(handle + 2) % 4];
      final ratio = start.height == 0 ? 0.0 : start.width / start.height;
      if (!keepAspect || ratio <= 0) return Rect.fromPoints(anchor, p);
      final dx = p.dx - anchor.dx;
      final dy = p.dy - anchor.dy;
      final w = math.max(dx.abs(), dy.abs() * ratio);
      final h = w / ratio;
      return Rect.fromPoints(
        anchor,
        anchor + Offset(dx < 0 ? -w : w, dy < 0 ? -h : h),
      );
    case 4:
      return Rect.fromPoints(Offset(start.left, p.dy), start.bottomRight);
    case 5:
      return Rect.fromPoints(start.topLeft, Offset(p.dx, start.bottom));
    case 6:
      return Rect.fromPoints(start.topLeft, Offset(start.right, p.dy));
    case 7:
      return Rect.fromPoints(Offset(p.dx, start.top), start.bottomRight);
    default:
      return start;
  }
}
