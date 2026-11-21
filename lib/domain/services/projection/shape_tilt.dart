// Project imports:
import '../../models/model3d/points.dart';
import '../../models/shapes/shape.dart';
import 'matrix3.dart';

/// Turns one shape around its own centre, leaving its drawn place alone.
class ShapeTilt {
  const ShapeTilt._(this._centre, this._turn);

  factory ShapeTilt.of(Shape shape) {
    final pose = shape.tilt;
    if (pose.isRest) return const ShapeTilt._(Point3.zero, null);
    final centre = shape.bounds.center;
    return ShapeTilt._(
      Point3(centre.dx, centre.dy, shape.z),
      Matrix3.pose(yaw: pose.yaw, pitch: pose.pitch, roll: pose.roll),
    );
  }

  final Point3 _centre;
  final Matrix3? _turn;

  /// Moves a point of the shape.
  Point3 apply(Point3 point) {
    final turn = _turn;
    return turn == null ? point : _centre + turn.apply(point - _centre);
  }

  /// Turns a direction, such as the way a side faces.
  Point3 turn(Point3 direction) => _turn?.apply(direction) ?? direction;
}
