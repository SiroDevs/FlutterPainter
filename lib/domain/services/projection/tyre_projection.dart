// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../models/model3d/point3.dart';
import '../../models/model3d/tyre_spec.dart';
import '../../models/shapes/shape.dart';
import '../../models/shapes/shape_gradient.dart';
import '../../models/shapes/shape_kind.dart';
import 'convex_hull.dart';
import 'view_transform.dart';

/// Builds the flat shapes of one tyre as seen through a view.
class TyreProjection {
  TyreProjection(this.spec, this.transform);

  static const int _hullSteps = 36;
  static const int _faceSteps = 24;
  static const int _shoulderSteps = 4;
  static const double _faceVisibility = 0.0001;

  final TyreSpec spec;
  final ViewTransform transform;

  double get _half => spec.width / 2;

  double get _rounding => math.min(
    spec.shoulder.clamp(0.0, 1.0).toDouble() * _half,
    spec.radius,
  );

  String get _groupId => 'tyre-${spec.name}';

  String get _groupName => spec.groupName ?? spec.name;

  /// Shapes in drawing order: body, visible treads, visible faces.
  List<Shape> build() => [_body(), ..._treads(), ..._faces()];

  Point3 _surface(double across, double radius, double angle) => Point3(
    spec.centre.dx + across,
    spec.centre.dy - radius * math.cos(angle),
    spec.centre.dz + radius * math.sin(angle),
  );

  List<Offset> _ring(double across, double radius, int steps) => [
    for (var step = 0; step < steps; step++)
      transform.flat(_surface(across, radius, 2 * math.pi * step / steps)),
  ];

  Shape _body() {
    final points = <Offset>[];
    for (final side in const [-1, 1]) {
      for (var step = 0; step <= _shoulderSteps; step++) {
        final sweep = math.pi / 2 * step / _shoulderSteps;
        final across = side * (_half - _rounding + _rounding * math.cos(sweep));
        final radius = spec.radius - _rounding + _rounding * math.sin(sweep);
        points.addAll(_ring(across, radius, _hullSteps));
      }
    }
    return Shape(
      kind: ShapeKind.polygon,
      points: convexHull(points),
      name: '${spec.name}Body',
      fill: spec.style.bodyFill,
      stroke: spec.style.bodyStroke,
      strokeWidth: spec.style.bodyStrokeWidth,
      groupId: _groupId,
      groupName: _groupName,
    );
  }

  List<Shape> _treads() {
    if (spec.treadCount <= 0) return const [];
    final sweep = 2 * math.pi / spec.treadCount;
    final halfSweep = sweep * spec.treadCover / 2;
    final flatHalf = math.max(_half - _rounding, _half * 0.3);
    final halfAcross = flatHalf * spec.treadSpan;
    final topRadius = spec.radius + spec.treadHeight;
    final treads = <Shape>[];
    for (var index = 0; index < spec.treadCount; index++) {
      final angle = spec.spin + index * sweep;
      final outward = Point3(0, -math.cos(angle), math.sin(angle));
      if (transform.turn(outward).dz >= 0) continue;
      final angles = [angle - halfSweep, angle, angle + halfSweep];
      treads.add(
        Shape(
          kind: ShapeKind.polygon,
          points: [
            for (final each in angles)
              transform.flat(_surface(-halfAcross, topRadius, each)),
            for (final each in angles.reversed)
              transform.flat(_surface(halfAcross, topRadius, each)),
          ],
          name: '${spec.name}Tread${index + 1}',
          fill: spec.style.treadFill,
          stroke: spec.style.treadStroke,
          strokeWidth: spec.style.treadStrokeWidth,
          groupId: _groupId,
          groupName: _groupName,
        ),
      );
    }
    return treads;
  }

  List<Shape> _faces() {
    final faces = <Shape>[];
    for (final side in const [-1, 1]) {
      final facing = transform.turn(Point3(side.toDouble(), 0, 0)).dz;
      if (facing >= -_faceVisibility) continue;
      final across = side * _half;
      faces
        ..add(
          _face(
            'Sidewall',
            across,
            (spec.radius - _rounding) * spec.sidewallShare,
            spec.style.sidewallFill,
            spec.style.sidewallGradient,
          ),
        )
        ..add(
          _face(
            'Hub',
            across,
            spec.radius * spec.hubShare,
            spec.style.hubFill,
            spec.style.hubGradient,
          ),
        );
    }
    return faces;
  }

  Shape _face(
    String label,
    double across,
    double radius,
    int fill,
    ShapeGradient? gradient,
  ) => Shape(
    kind: ShapeKind.polygon,
    points: _ring(across, radius, _faceSteps),
    name: '${spec.name}$label',
    fill: gradient?.firstColor ?? fill,
    gradient: gradient,
    stroke: null,
    groupId: _groupId,
    groupName: _groupName,
  );
}
