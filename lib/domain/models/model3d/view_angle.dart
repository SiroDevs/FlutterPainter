// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'part_pose.dart';

/// A named camera angle. Yaw and pitch are radians; positive yaw turns the
/// object's nose to the viewer's right. Each angle exports as one flat layer,
/// and may pose parts (by part id) differently from the rest pose or hide
/// them.
class ViewAngle extends Equatable {
  const ViewAngle({
    required this.name,
    this.yaw = 0,
    this.pitch = 0,
    this.scale = 1,
    this.poses = const {},
    this.hidden = const {},
  });

  final String name;
  final double yaw;
  final double pitch;
  final double scale;
  final Map<String, PartPose> poses;
  final Set<String> hidden;

  ViewAngle copyWith({
    String? name,
    double? yaw,
    double? pitch,
    double? scale,
    Map<String, PartPose>? poses,
    Set<String>? hidden,
  }) => ViewAngle(
    name: name ?? this.name,
    yaw: yaw ?? this.yaw,
    pitch: pitch ?? this.pitch,
    scale: scale ?? this.scale,
    poses: poses ?? this.poses,
    hidden: hidden ?? this.hidden,
  );

  @override
  List<Object?> get props => [name, yaw, pitch, scale, poses, hidden];
}
