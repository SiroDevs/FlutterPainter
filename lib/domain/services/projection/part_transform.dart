// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../models/model3d/model3d.dart';
import '../../models/model3d/part_pose.dart';
import '../../models/model3d/point3.dart';
import '../../models/model3d/view_angle.dart';

typedef _Joint = ({Point3 pivot, PartPose pose});

/// Moves one part before the camera sees it: it turns around its own joint,
/// then around every joint it hangs from, up to the root.
class PartTransform {
  const PartTransform._(this._joints);

  static const PartTransform none = PartTransform._([]);

  static const int _maxChain = 8;

  final List<_Joint> _joints;

  /// The movement of [partId] in [view]. A part with no joint, or posed at
  /// rest all the way up, does not move.
  factory PartTransform.forPart(
    String partId,
    Model3d model,
    ViewAngle view,
  ) {
    final joints = <_Joint>[];
    final visited = <String>{};
    String? current = partId;
    while (current != null && visited.length < _maxChain && visited.add(current)) {
      final rig = model.rigs[current];
      final pose = view.poses[current];
      if (rig != null && pose != null && !pose.isRest) {
        joints.add((pivot: rig.pivot, pose: pose));
      }
      current = rig?.parentId;
    }
    return joints.isEmpty ? none : PartTransform._(joints);
  }

  /// Moves a point of the part.
  Point3 apply(Point3 point) {
    var moved = point;
    for (final joint in _joints) {
      moved = joint.pivot + _rotate(moved - joint.pivot, joint.pose);
    }
    return moved;
  }

  /// Turns a direction, such as the way a surface faces.
  Point3 turn(Point3 direction) {
    var turned = direction;
    for (final joint in _joints) {
      turned = _rotate(turned, joint.pose);
    }
    return turned;
  }

  // Lean, then tilt, then turn: the same directions the camera uses.
  static Point3 _rotate(Point3 vector, PartPose pose) {
    final rollCos = math.cos(pose.roll);
    final rollSin = math.sin(pose.roll);
    final leanedAcross = vector.dx * rollCos - vector.dy * rollSin;
    final leanedDown = vector.dx * rollSin + vector.dy * rollCos;
    final pitchCos = math.cos(pose.pitch);
    final pitchSin = math.sin(pose.pitch);
    final tiltedDown = leanedDown * pitchCos - vector.dz * pitchSin;
    final tiltedAway = leanedDown * pitchSin + vector.dz * pitchCos;
    final yawCos = math.cos(pose.yaw);
    final yawSin = math.sin(pose.yaw);
    return Point3(
      leanedAcross * yawCos + tiltedAway * yawSin,
      tiltedDown,
      -leanedAcross * yawSin + tiltedAway * yawCos,
    );
  }
}
