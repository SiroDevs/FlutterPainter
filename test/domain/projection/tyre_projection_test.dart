// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/domain/models/model3d/point3.dart';
import 'package:flutter_painter/domain/models/model3d/tyre_spec.dart';
import 'package:flutter_painter/domain/models/model3d/view_angle.dart';
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/services/projection/tyre_projection.dart';
import 'package:flutter_painter/domain/services/projection/view_transform.dart';

const _pivot = Point3(61.35, 166, 0);

const _tyre = TyreSpec(
  name: 'Tyre',
  centre: Point3(61.35, 130.95, -40),
  radius: 32.55,
  width: 18.7,
  spin: 0.1,
);

List<Shape> _project(double yaw, {double pitch = 0}) => TyreProjection(
  _tyre,
  ViewTransform(ViewAngle(name: 'test', yaw: yaw, pitch: pitch), _pivot),
).build();

Shape _named(List<Shape> shapes, String name) =>
    shapes.firstWhere((shape) => shape.name == name);

bool _hasShape(List<Shape> shapes, String name) =>
    shapes.any((shape) => shape.name == name);

void main() {
  test('seen straight on the tyre is a plain upright block', () {
    final shapes = _project(0);
    final body = _named(shapes, 'TyreBody').unrotatedBounds;
    expect(body.left, closeTo(52.0, 0.2));
    expect(body.right, closeTo(70.7, 0.2));
    expect(body.top, closeTo(98.4, 0.2));
    expect(body.bottom, closeTo(163.5, 0.2));
    expect(_hasShape(shapes, 'TyreSidewall'), isFalse);
  });

  test('turning right shows the right sidewall at the right end', () {
    final shapes = _project(0.32);
    final body = _named(shapes, 'TyreBody').unrotatedBounds;
    final sidewall = _named(shapes, 'TyreSidewall').unrotatedBounds;
    expect(body.width, closeTo(36.7, 0.5));
    expect(sidewall.width, closeTo(17.8, 0.5));
    expect(sidewall.right, closeTo(body.right, 1.0));
  });

  test('turning left mirrors it with the sidewall at the left end', () {
    final shapes = _project(-0.32);
    final body = _named(shapes, 'TyreBody').unrotatedBounds;
    final sidewall = _named(shapes, 'TyreSidewall').unrotatedBounds;
    expect(body.width, closeTo(36.7, 0.5));
    expect(sidewall.left, closeTo(body.left, 1.0));
  });

  test('only the treads facing the viewer are drawn', () {
    final treads = _project(0.2).where((shape) => shape.name.contains('Tread'));
    expect(treads.length, 8);
  });

  test('spinning moves the treads without moving the tyre', () {
    final first = _project(0.2);
    final spun = TyreProjection(
      _tyre.copyWith(spin: 0.3),
      ViewTransform(const ViewAngle(name: 'test', yaw: 0.2), _pivot),
    ).build();
    final firstBody = _named(first, 'TyreBody').unrotatedBounds;
    final spunBody = _named(spun, 'TyreBody').unrotatedBounds;
    expect(spunBody, firstBody);
    expect(
      _named(first, 'TyreTread10').points,
      isNot(_named(spun, 'TyreTread10').points),
    );
  });

  test('every shape of a tyre shares one group', () {
    final groups = _project(0.2).map((shape) => shape.groupId).toSet();
    expect(groups, {'tyre-Tyre'});
  });
}
