// Project imports:
import '../../domain/models/model3d/model3d.dart';
import '../../domain/models/model3d/part_pose.dart';
import '../../domain/models/model3d/part_rig.dart';
import '../../domain/models/model3d/point3.dart';
import '../../domain/models/model3d/section_profile.dart';
import '../../domain/models/model3d/view_angle.dart';

List<double> point3ToJson(Point3 point) => [point.dx, point.dy, point.dz];

Point3 point3FromJson(Object? json, Point3 fallback) {
  if (json is! List || json.length < 3) return fallback;
  return Point3(
    (json[0] as num).toDouble(),
    (json[1] as num).toDouble(),
    (json[2] as num).toDouble(),
  );
}

double _number(Object? value, double fallback) =>
    value is num ? value.toDouble() : fallback;

Map<String, dynamic> poseToJson(PartPose pose) => {
  'yaw': pose.yaw,
  'pitch': pose.pitch,
  'roll': pose.roll,
};

PartPose poseFromJson(Map<String, dynamic> json) => PartPose(
  yaw: _number(json['yaw'], 0),
  pitch: _number(json['pitch'], 0),
  roll: _number(json['roll'], 0),
);

Map<String, dynamic> sectionToJson(SectionProfile section) => {
  'kind': section.kind.name,
  'sides': section.sides,
  'axis': section.axis.name,
};

SectionProfile sectionFromJson(Map<String, dynamic> json) => SectionProfile(
  kind: SectionKind.values.asNameMap()[json['kind']] ?? SectionKind.box,
  sides: (json['sides'] as int?) ?? SectionProfile.box.sides,
  axis: SectionAxis.values.asNameMap()[json['axis']] ?? SectionAxis.width,
);

Map<String, dynamic> viewToJson(ViewAngle view) => {
  'name': view.name,
  'yaw': view.yaw,
  'pitch': view.pitch,
  if (view.scale != 1) 'scale': view.scale,
  if (view.hidden.isNotEmpty) 'hidden': view.hidden.toList(),
  if (view.poses.isNotEmpty)
    'poses': {
      for (final entry in view.poses.entries)
        entry.key: poseToJson(entry.value),
    },
};

ViewAngle viewFromJson(Map<String, dynamic> json) => ViewAngle(
  name: (json['name'] as String?) ?? 'View',
  yaw: _number(json['yaw'], 0),
  pitch: _number(json['pitch'], 0),
  scale: _number(json['scale'], 1),
  hidden: {for (final id in (json['hidden'] as List?) ?? const []) id as String},
  poses: {
    for (final entry
        in ((json['poses'] as Map<String, dynamic>?) ?? const {}).entries)
      entry.key: poseFromJson(entry.value as Map<String, dynamic>),
  },
);

Map<String, dynamic> rigToJson(PartRig rig) => {
  'pivot': point3ToJson(rig.pivot),
  if (rig.parentId != null) 'parent': rig.parentId,
  if (rig.axisAngle != 0) 'axisAngle': rig.axisAngle,
  if (rig.fold != 0) 'fold': rig.fold,
  if (rig.bend != 0) 'bend': rig.bend,
};

PartRig rigFromJson(Map<String, dynamic> json) => PartRig(
  pivot: point3FromJson(json['pivot'], Point3.zero),
  parentId: json['parent'] as String?,
  axisAngle: _number(json['axisAngle'], 0),
  fold: _number(json['fold'], 0),
  bend: _number(json['bend'], 0),
);

Map<String, dynamic> model3dToJson(Model3d model) => {
  'pivot': point3ToJson(model.pivot),
  'views': [for (final view in model.views) viewToJson(view)],
  if (model.rigs.isNotEmpty)
    'rigs': {
      for (final entry in model.rigs.entries)
        entry.key: rigToJson(entry.value),
    },
};

Model3d model3dFromJson(Map<String, dynamic> json) => Model3d(
  pivot: point3FromJson(json['pivot'], const Model3d().pivot),
  views: [
    for (final view in (json['views'] as List?) ?? const [])
      viewFromJson(view as Map<String, dynamic>),
  ],
  rigs: {
    for (final entry
        in ((json['rigs'] as Map<String, dynamic>?) ?? const {}).entries)
      entry.key: rigFromJson(entry.value as Map<String, dynamic>),
  },
);
