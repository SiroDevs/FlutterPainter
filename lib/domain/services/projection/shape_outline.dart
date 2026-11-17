// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../models/shapes/shape.dart';
import '../../models/shapes/shape_kind.dart';

const int _ellipseSteps = 32;
const int _cornerSteps = 4;

/// The points around a shape in its drawing plane, rotation applied.
List<Offset> outlineOf(Shape shape) {
  final points = switch (shape.kind) {
    ShapeKind.rect => _rectOutline(shape),
    ShapeKind.ellipse => _ellipseOutline(shape),
    ShapeKind.line || ShapeKind.polygon || ShapeKind.freehand => shape.points,
  };
  if (shape.rotation == 0) return points;
  final centre = shape.unrotatedBounds.center;
  return [
    for (final point in points)
      Shape.rotatePoint(point, shape.rotation, centre),
  ];
}

List<Offset> _ellipseOutline(Shape shape) {
  final bounds = shape.unrotatedBounds;
  return [
    for (var step = 0; step < _ellipseSteps; step++)
      bounds.center +
          Offset(
            bounds.width / 2 * math.cos(2 * math.pi * step / _ellipseSteps),
            bounds.height / 2 * math.sin(2 * math.pi * step / _ellipseSteps),
          ),
  ];
}

List<Offset> _rectOutline(Shape shape) {
  final bounds = shape.unrotatedBounds;
  final radius = shape.effectiveRadius;
  if (radius <= 0) {
    return [
      bounds.topLeft,
      bounds.topRight,
      bounds.bottomRight,
      bounds.bottomLeft,
    ];
  }
  return [
    ..._cornerArc(bounds.topLeft + Offset(radius, radius), radius, math.pi),
    ..._cornerArc(
      bounds.topRight + Offset(-radius, radius),
      radius,
      math.pi * 1.5,
    ),
    ..._cornerArc(bounds.bottomRight + Offset(-radius, -radius), radius, 0),
    ..._cornerArc(
      bounds.bottomLeft + Offset(radius, -radius),
      radius,
      math.pi / 2,
    ),
  ];
}

List<Offset> _cornerArc(Offset centre, double radius, double startAngle) => [
  for (var step = 0; step <= _cornerSteps; step++)
    centre +
        Offset(
          radius * math.cos(startAngle + math.pi / 2 * step / _cornerSteps),
          radius * math.sin(startAngle + math.pi / 2 * step / _cornerSteps),
        ),
];
