// Dart imports:
import 'dart:ui';

// Project imports:
import '../model/shape.dart';

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
