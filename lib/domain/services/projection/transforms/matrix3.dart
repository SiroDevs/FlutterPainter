// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../models/model3d/points.dart';

/// A rotation of object space, stored as its three rows.
class Matrix3 {
  const Matrix3(this.top, this.middle, this.bottom);

  static const Matrix3 identity = Matrix3(
    Point3(1, 0, 0),
    Point3(0, 1, 0),
    Point3(0, 0, 1),
  );

  final Point3 top;
  final Point3 middle;
  final Point3 bottom;

  /// Lean around the front-back axis, then tilt around the left-right axis,
  /// then turn around the vertical one: the directions the camera uses.
  factory Matrix3.pose({double yaw = 0, double pitch = 0, double roll = 0}) {
    final leanCos = math.cos(roll);
    final leanSin = math.sin(roll);
    final tiltCos = math.cos(pitch);
    final tiltSin = math.sin(pitch);
    final turnCos = math.cos(yaw);
    final turnSin = math.sin(yaw);
    final lean = Matrix3(
      Point3(leanCos, -leanSin, 0),
      Point3(leanSin, leanCos, 0),
      const Point3(0, 0, 1),
    );
    final tilt = Matrix3(
      const Point3(1, 0, 0),
      Point3(0, tiltCos, -tiltSin),
      Point3(0, tiltSin, tiltCos),
    );
    final turn = Matrix3(
      Point3(turnCos, 0, turnSin),
      const Point3(0, 1, 0),
      Point3(-turnSin, 0, turnCos),
    );
    return turn * tilt * lean;
  }

  /// A turn of [angle] around [axis] (right-hand rule). No axis, no turn.
  factory Matrix3.aroundAxis(Point3 axis, double angle) {
    final length = math.sqrt(axis.dot(axis));
    if (length < 1e-12) return identity;
    final unit = axis * (1 / length);
    final cosine = math.cos(angle);
    final sine = math.sin(angle);
    final rest = 1 - cosine;
    return Matrix3(
      Point3(
        rest * unit.dx * unit.dx + cosine,
        rest * unit.dx * unit.dy - sine * unit.dz,
        rest * unit.dx * unit.dz + sine * unit.dy,
      ),
      Point3(
        rest * unit.dx * unit.dy + sine * unit.dz,
        rest * unit.dy * unit.dy + cosine,
        rest * unit.dy * unit.dz - sine * unit.dx,
      ),
      Point3(
        rest * unit.dx * unit.dz - sine * unit.dy,
        rest * unit.dy * unit.dz + sine * unit.dx,
        rest * unit.dz * unit.dz + cosine,
      ),
    );
  }

  Point3 apply(Point3 vector) =>
      Point3(top.dot(vector), middle.dot(vector), bottom.dot(vector));

  /// The turn that undoes this one.
  Matrix3 get transposed => Matrix3(
    Point3(top.dx, middle.dx, bottom.dx),
    Point3(top.dy, middle.dy, bottom.dy),
    Point3(top.dz, middle.dz, bottom.dz),
  );

  /// This turn applied after [other].
  Matrix3 operator *(Matrix3 other) {
    Point3 mix(Point3 row) =>
        other.top * row.dx + other.middle * row.dy + other.bottom * row.dz;
    return Matrix3(mix(top), mix(middle), mix(bottom));
  }
}
