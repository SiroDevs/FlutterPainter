// Package imports:
import 'package:equatable/equatable.dart';

/// A named camera angle. Yaw and pitch are radians; positive yaw turns the
/// object's nose to the viewer's right. Each angle exports as one flat layer.
class ViewAngle extends Equatable {
  const ViewAngle({
    required this.name,
    this.yaw = 0,
    this.pitch = 0,
    this.scale = 1,
  });

  final String name;
  final double yaw;
  final double pitch;
  final double scale;

  ViewAngle copyWith({
    String? name,
    double? yaw,
    double? pitch,
    double? scale,
  }) => ViewAngle(
    name: name ?? this.name,
    yaw: yaw ?? this.yaw,
    pitch: pitch ?? this.pitch,
    scale: scale ?? this.scale,
  );

  @override
  List<Object?> get props => [name, yaw, pitch, scale];
}
