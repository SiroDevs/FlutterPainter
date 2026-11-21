// Package imports:
import 'package:equatable/equatable.dart';

/// How far in front of or behind the drawing plane a shape can be placed.
const double kDepthRange = 120;

/// A point in object space: right, down, and away from the viewer.
class Point3 extends Equatable {
  const Point3(this.dx, this.dy, this.dz);

  static const Point3 zero = Point3(0, 0, 0);

  final double dx;
  final double dy;
  final double dz;

  Point3 operator +(Point3 other) =>
      Point3(dx + other.dx, dy + other.dy, dz + other.dz);

  Point3 operator -(Point3 other) =>
      Point3(dx - other.dx, dy - other.dy, dz - other.dz);

  Point3 operator *(double factor) =>
      Point3(dx * factor, dy * factor, dz * factor);

  double dot(Point3 other) => dx * other.dx + dy * other.dy + dz * other.dz;

  @override
  List<Object?> get props => [dx, dy, dz];
}
