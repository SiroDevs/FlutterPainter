// Project imports:
import '../../domain/models/model3d/model3d.dart';
import '../../domain/models/model3d/part_pose.dart';
import '../../domain/models/model3d/part_rig.dart';
import '../../domain/models/model3d/point3.dart';
import '../../domain/models/model3d/tyre_spec.dart';
import '../../domain/models/model3d/tyre_style.dart';
import '../../domain/models/model3d/view_angle.dart';
import 'gradient_mapper.dart';

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
};

PartRig rigFromJson(Map<String, dynamic> json) => PartRig(
  pivot: point3FromJson(json['pivot'], Point3.zero),
  parentId: json['parent'] as String?,
);

Map<String, dynamic> tyreStyleToJson(TyreStyle style) => {
  'bodyFill': style.bodyFill,
  'bodyStroke': style.bodyStroke,
  'bodyStrokeWidth': style.bodyStrokeWidth,
  'treadFill': style.treadFill,
  'treadStroke': style.treadStroke,
  'treadStrokeWidth': style.treadStrokeWidth,
  'sidewallFill': style.sidewallFill,
  if (style.sidewallGradient != null)
    'sidewallGradient': gradientToJson(style.sidewallGradient!),
  'hubFill': style.hubFill,
  if (style.hubGradient != null)
    'hubGradient': gradientToJson(style.hubGradient!),
};

TyreStyle tyreStyleFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return const TyreStyle();
  const defaults = TyreStyle();
  return TyreStyle(
    bodyFill: (json['bodyFill'] as int?) ?? defaults.bodyFill,
    bodyStroke: json.containsKey('bodyStroke')
        ? json['bodyStroke'] as int?
        : defaults.bodyStroke,
    bodyStrokeWidth: _number(json['bodyStrokeWidth'], defaults.bodyStrokeWidth),
    treadFill: json['treadFill'] as int?,
    treadStroke: json.containsKey('treadStroke')
        ? json['treadStroke'] as int?
        : defaults.treadStroke,
    treadStrokeWidth: _number(
      json['treadStrokeWidth'],
      defaults.treadStrokeWidth,
    ),
    sidewallFill: (json['sidewallFill'] as int?) ?? defaults.sidewallFill,
    sidewallGradient: gradientFromJson(json['sidewallGradient']),
    hubFill: (json['hubFill'] as int?) ?? defaults.hubFill,
    hubGradient: gradientFromJson(json['hubGradient']),
  );
}

Map<String, dynamic> tyreToJson(TyreSpec tyre) => {
  'name': tyre.name,
  if (tyre.groupName != null) 'groupName': tyre.groupName,
  'centre': point3ToJson(tyre.centre),
  'radius': tyre.radius,
  'width': tyre.width,
  'treadCount': tyre.treadCount,
  'treadCover': tyre.treadCover,
  'treadSpan': tyre.treadSpan,
  'treadHeight': tyre.treadHeight,
  'shoulder': tyre.shoulder,
  'sidewallShare': tyre.sidewallShare,
  'hubShare': tyre.hubShare,
  'spin': tyre.spin,
  'style': tyreStyleToJson(tyre.style),
};

TyreSpec tyreFromJson(Map<String, dynamic> json) {
  const defaults = TyreSpec(
    name: 'Tyre',
    centre: Point3.zero,
    radius: 1,
    width: 1,
  );
  return TyreSpec(
    name: (json['name'] as String?) ?? defaults.name,
    groupName: json['groupName'] as String?,
    centre: point3FromJson(json['centre'], defaults.centre),
    radius: _number(json['radius'], defaults.radius),
    width: _number(json['width'], defaults.width),
    treadCount: (json['treadCount'] as int?) ?? defaults.treadCount,
    treadCover: _number(json['treadCover'], defaults.treadCover),
    treadSpan: _number(json['treadSpan'], defaults.treadSpan),
    treadHeight: _number(json['treadHeight'], defaults.treadHeight),
    shoulder: _number(json['shoulder'], defaults.shoulder),
    sidewallShare: _number(json['sidewallShare'], defaults.sidewallShare),
    hubShare: _number(json['hubShare'], defaults.hubShare),
    spin: _number(json['spin'], defaults.spin),
    style: tyreStyleFromJson(json['style']),
  );
}

Map<String, dynamic> model3dToJson(Model3d model) => {
  'pivot': point3ToJson(model.pivot),
  'views': [for (final view in model.views) viewToJson(view)],
  'tyres': [for (final tyre in model.tyres) tyreToJson(tyre)],
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
  tyres: [
    for (final tyre in (json['tyres'] as List?) ?? const [])
      tyreFromJson(tyre as Map<String, dynamic>),
  ],
  rigs: {
    for (final entry
        in ((json['rigs'] as Map<String, dynamic>?) ?? const {}).entries)
      entry.key: rigFromJson(entry.value as Map<String, dynamic>),
  },
);
