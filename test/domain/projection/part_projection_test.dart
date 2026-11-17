import 'dart:ui';

import 'package:flutter_painter/data/mappers/drawing_mapper.dart';
import 'package:flutter_painter/domain/models/drawing/drawing.dart';
import 'package:flutter_painter/domain/models/drawing/paint_layer.dart';
import 'package:flutter_painter/domain/models/model3d/model3d.dart';
import 'package:flutter_painter/domain/models/model3d/part_pose.dart';
import 'package:flutter_painter/domain/models/model3d/part_rig.dart';
import 'package:flutter_painter/domain/models/model3d/point3.dart';
import 'package:flutter_painter/domain/models/model3d/view_angle.dart';
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/models/shapes/shape_kind.dart';
import 'package:flutter_painter/domain/services/projection/model_projection.dart';
import 'package:flutter_test/flutter_test.dart';

Shape _block(String name, String group, double left) => Shape(
  kind: ShapeKind.rect,
  points: [Offset(left, 0), Offset(left + 10, 10)],
  name: name,
  fill: 0xFF336699,
  groupId: group,
  groupName: group,
);

final _model = Model3d(
  pivot: const Point3(0, 10, 0),
  views: const [
    ViewAngle(name: 'Straight'),
    ViewAngle(name: 'Turned', poses: {'bar': PartPose(roll: 0.5)}),
    ViewAngle(name: 'NoBar', hidden: {'bar'}),
  ],
  rigs: const {'bar': PartRig(pivot: Point3(25, 5, 0))},
);

final _layer = PaintLayer(
  name: 'Bike',
  model: _model,
  shapes: [_block('Frame', 'frame', 0), _block('Bar', 'bar', 20)],
);

Shape _named(List<Shape> shapes, String name) =>
    shapes.firstWhere((shape) => shape.name == name);

void main() {
  test('a pose moves its own part in its own view only', () {
    final straight = projectLayer(_layer, _model.views[0]);
    final turned = projectLayer(_layer, _model.views[1]);
    expect(_named(turned, 'Bar').points, isNot(_named(straight, 'Bar').points));
    expect(_named(turned, 'Frame').points, _named(straight, 'Frame').points);
  });

  test('a part posed at rest projects exactly as without a joint', () {
    final withoutRig = _layer.copyWith(model: _model.copyWith(rigs: const {}));
    expect(
      _named(projectLayer(_layer, _model.views[0]), 'Bar').points,
      _named(projectLayer(withoutRig, _model.views[0]), 'Bar').points,
    );
  });

  test('a part hidden in a view is left out of it only', () {
    final hidden = projectLayer(_layer, _model.views[2]);
    expect(hidden.any((shape) => shape.name == 'Bar'), isFalse);
    expect(hidden.any((shape) => shape.name == 'Frame'), isTrue);
    final shown = projectLayer(_layer, _model.views[0]);
    expect(shown.any((shape) => shape.name == 'Bar'), isTrue);
  });

  test('joints and poses survive saving and loading', () {
    final drawing = Drawing(name: 'Rig', layers: [_layer]);
    expect(drawingFromJson(drawingToJson(drawing)), drawing);
  });
}
