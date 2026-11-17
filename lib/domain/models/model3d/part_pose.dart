// Package imports:
import 'package:equatable/equatable.dart';

/// How a part is turned around its joint in one view, in radians. Turn is
/// around the vertical axis, tilt around the left-right axis and lean around
/// the front-back axis.
class PartPose extends Equatable {
  const PartPose({this.yaw = 0, this.pitch = 0, this.roll = 0});

  static const PartPose rest = PartPose();

  final double yaw;
  final double pitch;
  final double roll;

  bool get isRest => yaw == 0 && pitch == 0 && roll == 0;

  PartPose copyWith({double? yaw, double? pitch, double? roll}) => PartPose(
    yaw: yaw ?? this.yaw,
    pitch: pitch ?? this.pitch,
    roll: roll ?? this.roll,
  );

  @override
  List<Object?> get props => [yaw, pitch, roll];
}
