// Package imports:
import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [dx, dy, dz];
}
