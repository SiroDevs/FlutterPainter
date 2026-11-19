// Dart imports:
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

// Project imports:
import '../../domain/models/drawing/drawing.dart';
import '../../domain/models/drawing/paint_layer.dart';
import '../../domain/models/drawing/project_format_exception.dart';
import '../../domain/models/drawing/reference_image.dart';
import '../../domain/models/model3d/part_pose.dart';
import '../../domain/models/model3d/section_profile.dart';
import '../../domain/models/shapes/shape.dart';
import '../../domain/models/shapes/shape_kind.dart';
import 'gradient_mapper.dart';
import 'model3d_mapper.dart';

/// The .flp file format: JSON, with colours as 0xAARRGGBB integers and any
/// background image embedded as base64. See the README for the full schema.
const flpFormat = 'flp';
const flpVersion = 3;
const flpPlainVersion = 2;

Map<String, dynamic> shapeToJson(Shape s) => {
  'kind': s.kind.name,
  'name': s.name,
  'points': [
    for (final p in s.points) [p.dx, p.dy],
  ],
  'fill': s.fill,
  if (s.gradient != null) 'gradient': gradientToJson(s.gradient!),
  'stroke': s.stroke,
  'strokeWidth': s.strokeWidth,
  'radius': s.radius,
  if (s.groupId != null) 'groupId': s.groupId,
  if (s.groupId != null && s.groupName != null) 'groupName': s.groupName,
  if (s.rotation != 0) 'rotation': s.rotation,
  if (!s.visible) 'visible': false,
  if (s.depth != 0) 'depth': s.depth,
  if (s.thickness != 0) 'thickness': s.thickness,
  if (!s.tilt.isRest) 'tilt': poseToJson(s.tilt),
  if (!s.section.isBox) 'section': sectionToJson(s.section),
};

Shape shapeFromJson(Map<String, dynamic> j) => Shape(
  kind: ShapeKind.values.byName(j['kind'] as String),
  name: (j['name'] as String?) ?? '',
  points: [
    for (final p in j['points'] as List)
      Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()),
  ],
  fill: j['fill'] as int?,
  gradient: gradientFromJson(j['gradient']),
  stroke: j['stroke'] as int?,
  strokeWidth: ((j['strokeWidth'] as num?) ?? 1).toDouble(),
  radius: ((j['radius'] as num?) ?? 0).toDouble(),
  groupId: j['groupId'] as String?,
  groupName: j['groupName'] as String?,
  rotation: ((j['rotation'] as num?) ?? 0).toDouble(),
  visible: (j['visible'] as bool?) ?? true,
  depth: ((j['depth'] as num?) ?? 0).toDouble(),
  thickness: ((j['thickness'] as num?) ?? 0).toDouble(),
  tilt: j['tilt'] is Map<String, dynamic>
      ? poseFromJson(j['tilt'] as Map<String, dynamic>)
      : PartPose.rest,
  section: j['section'] is Map<String, dynamic>
      ? sectionFromJson(j['section'] as Map<String, dynamic>)
      : SectionProfile.box,
);

Map<String, dynamic> layerToJson(PaintLayer l) => {
  'name': l.name,
  'visible': l.visible,
  'shapes': [for (final s in l.shapes) shapeToJson(s)],
  if (l.image != null) 'image': referenceToJson(l.image!),
  if (l.model != null) 'model3d': model3dToJson(l.model!),
};

PaintLayer layerFromJson(Map<String, dynamic> j) => PaintLayer(
  name: j['name'] as String,
  visible: (j['visible'] as bool?) ?? true,
  shapes: [
    for (final s in j['shapes'] as List)
      shapeFromJson(s as Map<String, dynamic>),
  ],
  image: j['image'] == null
      ? null
      : referenceFromJson(j['image'] as Map<String, dynamic>),
  model: j['model3d'] == null
      ? null
      : model3dFromJson(j['model3d'] as Map<String, dynamic>),
);

Map<String, dynamic> referenceToJson(ReferenceImage r) => {
  'id': r.id,
  'x': r.x,
  'y': r.y,
  // `scale` is the horizontal scale, as in version 1 files.
  'scale': r.scaleX,
  'scaleY': r.scaleY,
  'opacity': r.opacity,
  'visible': r.visible,
  'data': base64Encode(r.bytes),
};

ReferenceImage? referenceFromJson(Map<String, dynamic> j) {
  final data = j['data'] as String?;
  if (data == null) return null;
  final Uint8List bytes = base64Decode(data);
  return ReferenceImage(
    bytes: bytes,
    id: (j['id'] as String?) ?? ReferenceImage.idOf(bytes),
    x: ((j['x'] as num?) ?? 0).toDouble(),
    y: ((j['y'] as num?) ?? 0).toDouble(),
    scaleX: ((j['scale'] as num?) ?? 1).toDouble(),
    // Files from before stretching have no `scaleY`: keep the proportions.
    scaleY: ((j['scaleY'] as num?) ?? (j['scale'] as num?) ?? 1).toDouble(),
    opacity: ((j['opacity'] as num?) ?? 0.5).toDouble(),
    visible: (j['visible'] as bool?) ?? true,
  );
}

Map<String, dynamic> drawingToMap(Drawing d) => {
  'format': flpFormat,
  // Files without a 3D layer stay readable by older versions of the app.
  'version': d.layers.any((layer) => layer.model != null)
      ? flpVersion
      : flpPlainVersion,
  'name': d.name,
  'width': d.width,
  'height': d.height,
  'layers': [for (final l in d.layers) layerToJson(l)],
};

/// Reads a project map. Throws [ProjectFormatException] when the map is from a
/// newer version of the format or is not a valid project.
Drawing drawingFromMap(Map<String, dynamic> j) {
  final format = j['format'];
  if (format != null && format != flpFormat) {
    throw ProjectFormatException(
      ProjectFormatProblem.damaged,
      'unknown format "$format"',
    );
  }
  final version = j['version'];
  if (version is int && version > flpVersion) {
    throw ProjectFormatException(
      ProjectFormatProblem.newerVersion,
      'file version $version, this app reads up to $flpVersion',
    );
  }
  try {
    return _drawingFromMap(j);
  } catch (e) {
    // Hand-edited or truncated files surface as cast, range and name errors.
    if (e is TypeError ||
        e is ArgumentError ||
        e is FormatException ||
        e is StateError) {
      throw ProjectFormatException(ProjectFormatProblem.damaged, '$e');
    }
    rethrow;
  }
}

Drawing _drawingFromMap(Map<String, dynamic> j) {
  final layers = <PaintLayer>[
    for (final l in j['layers'] as List)
      layerFromJson(l as Map<String, dynamic>),
  ];
  // Version 1 files kept one background picture on the drawing itself. It sat
  // under everything, so it moves onto the bottom layer.
  final legacy = j['reference'];
  if (legacy is Map<String, dynamic> && layers.isNotEmpty) {
    final image = referenceFromJson(legacy);
    if (image != null && layers.first.image == null) {
      layers[0] = layers.first.copyWith(image: image);
    }
  }
  return Drawing(
    name: (j['name'] as String?) ?? 'Untitled',
    width: ((j['width'] as num?) ?? 120).toDouble(),
    height: ((j['height'] as num?) ?? 170).toDouble(),
    layers: layers,
  );
}

String drawingToJson(Drawing d, {bool pretty = false}) {
  final map = drawingToMap(d);
  return pretty ? JsonEncoder.withIndent('  ').convert(map) : jsonEncode(map);
}

/// Throws [ProjectFormatException] for anything that is not a readable project.
Drawing drawingFromJson(String text) {
  final Object? decoded;
  try {
    decoded = jsonDecode(text);
  } on FormatException catch (e) {
    throw ProjectFormatException(ProjectFormatProblem.damaged, e.message);
  }
  if (decoded is! Map<String, dynamic>) {
    throw const ProjectFormatException(
      ProjectFormatProblem.damaged,
      'expected a JSON object',
    );
  }
  return drawingFromMap(decoded);
}
