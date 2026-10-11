// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

enum ShapeKind { rect, ellipse, line, polygon, freehand }

/// One drawable thing. Colours are 0xAARRGGBB ints (null = not painted) so the
/// model stays plain data and round-trips through JSON untouched.
///
/// - rect / ellipse: `points` holds two opposite corners.
/// - line / polygon: `points` are the vertices (polygon is closed).
/// - freehand: `points` are sampled along the stroke and drawn smoothed.
class Shape {
  Shape({
    required this.kind,
    required this.points,
    this.name = '',
    this.fill,
    this.stroke,
    this.strokeWidth = 1,
    this.radius = 0,
  });

  ShapeKind kind;
  String name;
  List<Offset> points;
  int? fill;
  int? stroke;
  double strokeWidth;
  double radius;

  bool get isClosed => kind != ShapeKind.line && kind != ShapeKind.freehand;
  bool get usesVertices => kind == ShapeKind.line || kind == ShapeKind.polygon;

  Rect get bounds {
    if (kind == ShapeKind.rect || kind == ShapeKind.ellipse) {
      return Rect.fromPoints(points[0], points[1]);
    }
    var r = Rect.fromPoints(points.first, points.first);
    for (final p in points) {
      r = Rect.fromLTRB(math.min(r.left, p.dx), math.min(r.top, p.dy),
          math.max(r.right, p.dx), math.max(r.bottom, p.dy));
    }
    return r;
  }

  /// Corner radius after clamping to what the rectangle can actually show.
  double get effectiveRadius {
    final b = bounds;
    return math.min(radius, math.min(b.width, b.height) / 2);
  }

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

  /// Quadratic smoothing through segment midpoints. The exporter emits the same
  /// maths, so what you see here is what the game draws.
  static void smoothInto(Path path, List<Offset> pts) {
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

  void draw(Canvas canvas, Paint paint) {
    final path = buildPath();
    if (isClosed && fill != null) {
      paint
        ..style = PaintingStyle.fill
        ..color = Color(fill!);
      canvas.drawPath(path, paint);
    }
    if (stroke != null) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Color(stroke!);
      canvas.drawPath(path, paint);
    }
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

  static Offset _closest(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (len2 == 0) return a;
    final ap = p - a;
    final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / len2).clamp(0.0, 1.0).toDouble();
    return a + ab * t;
  }

  static double _segmentDistance(Offset p, Offset a, Offset b) =>
      (p - _closest(p, a, b)).distance;

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

  /// Maps [pts] from the box [from] into the box [to] (used for resizing).
  static List<Offset> remap(List<Offset> pts, Rect from, Rect to) {
    final sx = from.width == 0 ? 1.0 : to.width / from.width;
    final sy = from.height == 0 ? 1.0 : to.height / from.height;
    return [
      for (final p in pts)
        Offset(to.left + (p.dx - from.left) * sx, to.top + (p.dy - from.top) * sy),
    ];
  }

  Shape copy() => Shape(
        kind: kind,
        name: name,
        points: List.of(points),
        fill: fill,
        stroke: stroke,
        strokeWidth: strokeWidth,
        radius: radius,
      );

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'name': name,
        'points': [
          for (final p in points) [p.dx, p.dy],
        ],
        'fill': fill,
        'stroke': stroke,
        'strokeWidth': strokeWidth,
        'radius': radius,
      };

  factory Shape.fromJson(Map<String, dynamic> j) => Shape(
        kind: ShapeKind.values.byName(j['kind'] as String),
        name: (j['name'] as String?) ?? '',
        points: [
          for (final p in j['points'] as List)
            Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()),
        ],
        fill: j['fill'] as int?,
        stroke: j['stroke'] as int?,
        strokeWidth: ((j['strokeWidth'] as num?) ?? 1).toDouble(),
        radius: ((j['radius'] as num?) ?? 0).toDouble(),
      );
}
