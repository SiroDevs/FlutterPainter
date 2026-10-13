// Dart imports:
import 'dart:ui';

// Project imports:
import '../models/shape.dart';
import '../models/shape_kind.dart';

/// Quadratic smoothing through segment midpoints. The Dart exporter emits the
/// same maths, so what you see in the editor is what the game draws.
void smoothInto(Path path, List<Offset> pts) {
  if (pts.length < 3) {
    path.addPolygon(pts, false);
    return;
  }
  path.moveTo(pts.first.dx, pts.first.dy);
  for (var i = 1; i < pts.length - 1; i++) {
    final mid = (pts[i] + pts[i + 1]) / 2;
    path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
  }
  path.lineTo(pts.last.dx, pts.last.dy);
}

Offset _closest(Offset p, Offset a, Offset b) {
  final ab = b - a;
  final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
  if (len2 == 0) return a;
  final ap = p - a;
  final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / len2).clamp(0.0, 1.0).toDouble();
  return a + ab * t;
}

double _segmentDistance(Offset p, Offset a, Offset b) =>
    (p - _closest(p, a, b)).distance;

/// Geometry for a [Shape]: its outline, hit-testing and edge lookup.
extension ShapeGeometry on Shape {
  Path buildPath() {
    final path = Path();
    switch (kind) {
      case ShapeKind.rect:
        final r = effectiveRadius;
        path.addRRect(RRect.fromRectXY(bounds, r, r));
      case ShapeKind.ellipse:
        path.addOval(bounds);
      case ShapeKind.polygon:
        path.addPolygon(points, true);
      case ShapeKind.line:
        path.addPolygon(points, false);
      case ShapeKind.freehand:
        smoothInto(path, points);
    }
    return path;
  }

  bool hitTest(Offset p, double tol) {
    final reach = tol + (stroke != null ? strokeWidth / 2 : 0);
    if (!isClosed) return _nearPolyline(p, reach, closed: false);
    if (buildPath().contains(p)) return true;
    final b = bounds;
    if (b.width < 2 * tol || b.height < 2 * tol) return b.inflate(tol).contains(p);
    if (stroke == null) return false;
    return kind == ShapeKind.polygon
        ? _nearPolyline(p, reach, closed: true)
        : b.inflate(reach).contains(p) && !b.deflate(reach).contains(p);
  }

  bool _nearPolyline(Offset p, double reach, {required bool closed}) {
    final n = points.length;
    for (var i = 0; i < (closed ? n : n - 1); i++) {
      if (_segmentDistance(p, points[i], points[(i + 1) % n]) <= reach) {
        return true;
      }
    }
    return n == 1 && (p - points.first).distance <= reach;
  }

  /// The edge of a line or polygon nearest [p] within [tol]: its index (the edge
  /// runs from points[index] to the next point) and the closest point on it.
  ({int index, Offset point})? nearestSegment(Offset p, double tol) {
    final n = points.length;
    if (n < 2) return null;
    int? best;
    var bestPoint = Offset.zero;
    var bestDist = tol;
    final edges = kind == ShapeKind.polygon ? n : n - 1;
    for (var i = 0; i < edges; i++) {
      final q = _closest(p, points[i], points[(i + 1) % n]);
      final d = (p - q).distance;
      if (d <= bestDist) {
        bestDist = d;
        best = i;
        bestPoint = q;
      }
    }
    return best == null ? null : (index: best, point: bestPoint);
  }
}
