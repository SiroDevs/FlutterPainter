// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../models/model3d/point3.dart';
import '../../models/model3d/view_angle.dart';
import 'part_transform.dart';

/// Turns object-space points and directions into the flat view.
class ViewTransform {
  ViewTransform(this.angle, this.pivot, {this.part = PartTransform.none})
    : scale = angle.scale,
      _yawCos = math.cos(_limited(angle.yaw)),
      _yawSin = math.sin(_limited(angle.yaw)),
      _pitchCos = math.cos(_limited(angle.pitch)),
      _pitchSin = math.sin(_limited(angle.pitch));

  static const double _limit = 1.48;

  final ViewAngle angle;
  final Point3 pivot;
  final PartTransform part;
  final double scale;
  final double _yawCos;
  final double _yawSin;
  final double _pitchCos;
  final double _pitchSin;

  static double _limited(double radians) =>
      radians.clamp(-_limit, _limit).toDouble();

  /// The same camera, seeing a part that moves by [movement] first.
  ViewTransform forPart(PartTransform movement) =>
      ViewTransform(angle, pivot, part: movement);

  /// Rotates a direction; its depth is negative when it faces the viewer.
  Point3 turn(Point3 direction) => _rotate(part.turn(direction));

  Point3 _rotate(Point3 direction) {
    final turnedAcross =
        direction.dx * _yawCos + direction.dz * _yawSin;
    final turnedAway =
        -direction.dx * _yawSin + direction.dz * _yawCos;
    return Point3(
      turnedAcross,
      direction.dy * _pitchCos - turnedAway * _pitchSin,
      direction.dy * _pitchSin + turnedAway * _pitchCos,
    );
  }

  /// Projects a point around the pivot, keeping its depth.
  Point3 project(Point3 point) {
    final turned = _rotate(part.apply(point) - pivot);
    return Point3(
      pivot.dx + turned.dx * scale,
      pivot.dy + turned.dy * scale,
      turned.dz,
    );
  }

  /// Projects a point onto the flat drawing.
  Offset flat(Point3 point) {
    final projected = project(point);
    return Offset(projected.dx, projected.dy);
  }
}
