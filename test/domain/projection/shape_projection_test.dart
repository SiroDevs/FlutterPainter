import 'dart:ui';

import 'package:flutter_painter/domain/models/model3d/point3.dart';
import 'package:flutter_painter/domain/models/model3d/view_angle.dart';
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/models/shapes/shape_kind.dart';
import 'package:flutter_painter/domain/services/projection/shape_projection.dart';
import 'package:flutter_painter/domain/services/projection/view_transform.dart';
import 'package:flutter_test/flutter_test.dart';

const _pivot = Point3(0, 0, 0);

Shape _block({double thickness = 0}) => Shape(
  kind: ShapeKind.rect,
  points: const [Offset(0, 0), Offset(10, 10)],
  name: 'Block',
  fill: 0xFF336699,
  thickness: thickness,
);

ViewTransform _view(double yaw) =>
    ViewTransform(ViewAngle(name: 'test', yaw: yaw), _pivot);

void main() {
  test('a flat shape stays one polygon with no depth data left', () {
    final result = projectShape(_block(), _view(0));
    expect(result.length, 1);
    expect(result.single.kind, ShapeKind.polygon);
    expect(result.single.depth, 0);
    expect(result.single.points.first, const Offset(0, 0));
  });

  test('an extruded shape turned right shows its right side first', () {
    final result = projectShape(_block(thickness: 10), _view(0.3));
    expect(result.length, 2);
    expect(result.first.name, 'BlockSide2');
    expect(result.last.name, 'Block');
  });

  test('turned left it shows its left side instead', () {
    final result = projectShape(_block(thickness: 10), _view(-0.3));
    expect(result.first.name, 'BlockSide4');
  });

  test('seen straight on an extruded shape has no visible sides', () {
    expect(projectShape(_block(thickness: 10), _view(0)).length, 1);
  });

  test('a shape further away shifts with the turn', () {
    final near = projectShape(_block(), _view(0.3)).single.points.first;
    final far = projectShape(
      _block().copyWith(depth: 20),
      _view(0.3),
    ).single.points.first;
    expect(far.dx, greaterThan(near.dx));
  });
}
