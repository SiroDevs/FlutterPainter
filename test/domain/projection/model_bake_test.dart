import 'dart:ui';

import 'package:flutter_painter/data/mappers/drawing_mapper.dart';
import 'package:flutter_painter/domain/models/drawing/drawing.dart';
import 'package:flutter_painter/domain/models/drawing/paint_layer.dart';
import 'package:flutter_painter/domain/models/model3d/model3d.dart';
import 'package:flutter_painter/domain/models/model3d/point3.dart';
import 'package:flutter_painter/domain/models/model3d/tyre_spec.dart';
import 'package:flutter_painter/domain/models/model3d/view_angle.dart';
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/models/shapes/shape_kind.dart';
import 'package:flutter_painter/domain/services/code_export/dart_exporter.dart';
import 'package:flutter_painter/domain/services/projection/model_baker.dart';
import 'package:flutter_test/flutter_test.dart';

final _model = Model3d(
  pivot: const Point3(61.35, 166, 0),
  views: const [
    ViewAngle(name: 'FacingLeft', yaw: -0.32),
    ViewAngle(name: 'FacingStraight'),
    ViewAngle(name: 'FacingRight', yaw: 0.32),
  ],
  tyres: const [
    TyreSpec(
      name: 'BikeTyre',
      centre: Point3(61.35, 130.95, -40),
      radius: 32.55,
      width: 18.7,
    ),
  ],
);

final _drawing = Drawing(
  name: 'Rider',
  layers: [
    PaintLayer(
      name: 'Bike',
      model: _model,
      shapes: const [
        Shape(
          kind: ShapeKind.rect,
          points: [Offset(50, 90), Offset(72, 100)],
          name: 'Fender',
          fill: 0xFF3A3D4E,
          groupId: 'group-1',
          groupName: 'Fender',
          depth: -40,
          thickness: 4,
        ),
      ],
    ),
  ],
);

void main() {
  test('baking gives one flat layer per view', () {
    final baked = bakeModelLayers(_drawing);
    expect(baked.layers.map((layer) => layer.name), [
      'FacingLeft',
      'FacingStraight',
      'FacingRight',
    ]);
    expect(baked.layers.every((layer) => layer.model == null), isTrue);
    expect(baked.layers.every((layer) => layer.shapes.isNotEmpty), isTrue);
  });

  test('drawings without a 3D layer are left untouched', () {
    const plain = Drawing(name: 'Plain');
    expect(identical(bakeModelLayers(plain), plain), isTrue);
  });

  test('a 3D drawing survives saving and loading', () {
    final loaded = drawingFromJson(drawingToJson(_drawing));
    expect(loaded, _drawing);
  });

  test('only 3D drawings need the newer file version', () {
    expect(drawingToMap(_drawing)['version'], 3);
    expect(drawingToMap(const Drawing(name: 'Plain'))['version'], 2);
  });

  test('the exporter writes one layer class per view', () {
    final paths = DartExporter(_drawing).generate().map((file) => file.path);
    expect(paths.any((path) => path.contains('facing_left')), isTrue);
    expect(paths.any((path) => path.contains('facing_right')), isTrue);
  });
}
