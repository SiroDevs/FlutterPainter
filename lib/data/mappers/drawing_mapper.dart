// Dart imports:
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

// Project imports:
import '../../domain/models/drawing.dart';
import '../../domain/models/paint_layer.dart';
import '../../domain/models/reference_image.dart';
import '../../domain/models/shape.dart';
import '../../domain/models/shape_kind.dart';

/// The .flp file format: JSON, with colours as 0xAARRGGBB integers and any
/// background image embedded as base64. See the README for the full schema.
const flpFormat = 'flp';
const flpVersion = 1;

Map<String, dynamic> shapeToJson(Shape s) => {
      'kind': s.kind.name,
      'name': s.name,
      'points': [
        for (final p in s.points) [p.dx, p.dy],
      ],
      'fill': s.fill,
      'stroke': s.stroke,
      'strokeWidth': s.strokeWidth,
      'radius': s.radius,
    };

Shape shapeFromJson(Map<String, dynamic> j) => Shape(
      kind: ShapeKind.values.byName(j['kind'] as String),
      name: (j['name'] as String?) ?? '',
      points: [
        for (final p in j['points'] as List)
          Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()),
      ],
      fill: j['fill'] as int?,
      stroke: j['stroke'] as int?,
      strokeWidth: ((j['strokeWidth'] as num?) ?? 1).toDouble(),
      radius: ((j['radius'] as num?) ?? 0).toDouble(),
    );

Map<String, dynamic> layerToJson(PaintLayer l) => {
      'name': l.name,
      'visible': l.visible,
      'shapes': [for (final s in l.shapes) shapeToJson(s)],
    };

PaintLayer layerFromJson(Map<String, dynamic> j) => PaintLayer(
      name: j['name'] as String,
      visible: (j['visible'] as bool?) ?? true,
      shapes: [
        for (final s in j['shapes'] as List) shapeFromJson(s as Map<String, dynamic>),
      ],
    );

Map<String, dynamic> referenceToJson(ReferenceImage r) => {
      'id': r.id,
      'x': r.x,
      'y': r.y,
      'scale': r.scale,
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
    scale: ((j['scale'] as num?) ?? 1).toDouble(),
    opacity: ((j['opacity'] as num?) ?? 0.5).toDouble(),
    visible: (j['visible'] as bool?) ?? true,
  );
}

Map<String, dynamic> drawingToMap(Drawing d) => {
      'format': flpFormat,
      'version': flpVersion,
      'name': d.name,
      'width': d.width,
      'height': d.height,
      'layers': [for (final l in d.layers) layerToJson(l)],
      if (d.reference != null) 'reference': referenceToJson(d.reference!),
    };

Drawing drawingFromMap(Map<String, dynamic> j) => Drawing(
      name: (j['name'] as String?) ?? 'Untitled',
      width: ((j['width'] as num?) ?? 120).toDouble(),
      height: ((j['height'] as num?) ?? 170).toDouble(),
      layers: [
        for (final l in j['layers'] as List) layerFromJson(l as Map<String, dynamic>),
      ],
      reference: j['reference'] == null
          ? null
          : referenceFromJson(j['reference'] as Map<String, dynamic>),
    );

String drawingToJson(Drawing d, {bool pretty = false}) {
  final map = drawingToMap(d);
  return pretty
      ? JsonEncoder.withIndent('  ').convert(map)
      : jsonEncode(map);
}

Drawing drawingFromJson(String text) =>
    drawingFromMap(jsonDecode(text) as Map<String, dynamic>);
