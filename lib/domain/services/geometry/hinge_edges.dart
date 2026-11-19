// Dart imports:
import 'dart:ui';

// Project imports:
import '../../models/shapes/shape.dart';
import '../../models/shapes/shape_kind.dart';

/// A straight side of a shape and the way it faces outward (a unit vector).
typedef HingeEdge = ({Offset start, Offset end, Offset outward});

/// The straight sides a new face can be hinged on: four for a rectangle, one
/// per segment for a polygon, none for round or open shapes. A rectangle's
/// sides come in the order top, right, bottom, left.
List<HingeEdge> hingeEdgesOf(Shape shape) {
  final corners = switch (shape.kind) {
    ShapeKind.rect => _turned(shape, _rectCorners(shape)),
    ShapeKind.polygon => _turned(shape, shape.points),
    ShapeKind.ellipse ||
    ShapeKind.line ||
    ShapeKind.freehand => const <Offset>[],
  };
  if (corners.length < 3) return const [];
  final centre =
      corners.fold(Offset.zero, (total, corner) => total + corner) /
      corners.length.toDouble();
  return [
    for (var index = 0; index < corners.length; index++)
      _edge(corners[index], corners[(index + 1) % corners.length], centre),
  ];
}

List<Offset> _rectCorners(Shape shape) {
  final bounds = shape.unrotatedBounds;
  return [
    bounds.topLeft,
    bounds.topRight,
    bounds.bottomRight,
    bounds.bottomLeft,
  ];
}

List<Offset> _turned(Shape shape, List<Offset> points) {
  if (shape.rotation == 0) return points;
  final centre = shape.unrotatedBounds.center;
  return [
    for (final point in points) Shape.rotatePoint(point, shape.rotation, centre),
  ];
}

HingeEdge _edge(Offset start, Offset end, Offset centre) {
  final along = end - start;
  final length = along.distance;
  var outward = length < 1e-9
      ? const Offset(0, -1)
      : Offset(along.dy, -along.dx) / length;
  final middle = (start + end) / 2;
  final away = middle - centre;
  if (outward.dx * away.dx + outward.dy * away.dy < 0) outward = -outward;
  return (start: start, end: end, outward: outward);
}
