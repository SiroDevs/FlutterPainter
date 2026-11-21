// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../models/model3d/view_angle.dart';
import '../../../models/model3d/world_axis.dart';

const double _usableShare = 0.15;

/// One world axis drawn as an arrow from the middle of a selection.
class AxisHandle {
  const AxisHandle({
    required this.axis,
    required this.origin,
    required this.tip,
    required this.usable,
  });

  final WorldAxis axis;
  final Offset origin;
  final Offset tip;

  /// False when the axis points almost straight at the viewer, so dragging
  /// along it would be unreliable.
  final bool usable;
}

/// How far the screen moves for one unit along [axis] seen through [camera].
Offset axisOnScreen(ViewAngle camera, WorldAxis axis) {
  final yaw = camera.yaw;
  final pitch = camera.pitch;
  final direction = switch (axis) {
    WorldAxis.x => Offset(math.cos(yaw), math.sin(yaw) * math.sin(pitch)),
    WorldAxis.y => Offset(0, math.cos(pitch)),
    WorldAxis.z => Offset(math.sin(yaw), -math.cos(yaw) * math.sin(pitch)),
  };
  return direction * camera.scale;
}

/// The three axes as arrows of [length] from [origin]. An axis that points
/// toward the viewer is drawn shorter.
List<AxisHandle> axisHandles(ViewAngle camera, Offset origin, double length) => [
  for (final axis in WorldAxis.values)
    _handle(camera, axis, origin, length),
];

AxisHandle _handle(
  ViewAngle camera,
  WorldAxis axis,
  Offset origin,
  double length,
) {
  final share = camera.scale == 0
      ? Offset.zero
      : axisOnScreen(camera, axis) / camera.scale;
  return AxisHandle(
    axis: axis,
    origin: origin,
    tip: origin + share * length,
    usable: share.distance >= _usableShare,
  );
}
