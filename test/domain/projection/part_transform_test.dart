import 'dart:math' as math;

import 'package:flutter_painter/domain/models/model3d/model3d.dart';
import 'package:flutter_painter/domain/models/model3d/part_pose.dart';
import 'package:flutter_painter/domain/models/model3d/part_rig.dart';
import 'package:flutter_painter/domain/models/model3d/point3.dart';
import 'package:flutter_painter/domain/models/model3d/view_angle.dart';
import 'package:flutter_painter/domain/services/projection/part_transform.dart';
import 'package:flutter_test/flutter_test.dart';

const _quarterTurn = math.pi / 2;

Matcher _near(Point3 expected) => predicate<Point3>(
  (actual) =>
      (actual.dx - expected.dx).abs() < 1e-9 &&
      (actual.dy - expected.dy).abs() < 1e-9 &&
      (actual.dz - expected.dz).abs() < 1e-9,
  'is near $expected',
);

PartTransform _transform(
  String partId,
  Map<String, PartRig> rigs,
  Map<String, PartPose> poses,
) => PartTransform.forPart(
  partId,
  Model3d(rigs: rigs),
  ViewAngle(name: 'test', poses: poses),
);

void main() {
  test('a part without a pose does not move', () {
    final transform = _transform(
      'arm',
      {'arm': const PartRig(pivot: Point3.zero)},
      const {},
    );
    expect(transform.apply(const Point3(1, 2, 3)), _near(const Point3(1, 2, 3)));
  });

  test('a part with a pose but no joint does not move', () {
    final transform = _transform('arm', const {}, {
      'arm': const PartPose(yaw: _quarterTurn),
    });
    expect(transform.apply(const Point3(0, 0, 10)), _near(const Point3(0, 0, 10)));
  });

  test('turning swings the front of a part to the right', () {
    final transform = _transform(
      'arm',
      {'arm': const PartRig(pivot: Point3.zero)},
      {'arm': const PartPose(yaw: _quarterTurn)},
    );
    expect(transform.apply(const Point3(0, 0, 10)), _near(const Point3(10, 0, 0)));
  });

  test('leaning moves the top of a part to the right', () {
    final transform = _transform(
      'arm',
      {'arm': const PartRig(pivot: Point3.zero)},
      {'arm': const PartPose(roll: _quarterTurn)},
    );
    expect(transform.apply(const Point3(0, -10, 0)), _near(const Point3(10, 0, 0)));
  });

  test('tilting moves the far side of a part up', () {
    final transform = _transform(
      'arm',
      {'arm': const PartRig(pivot: Point3.zero)},
      {'arm': const PartPose(pitch: _quarterTurn)},
    );
    expect(transform.apply(const Point3(0, 0, 10)), _near(const Point3(0, -10, 0)));
  });

  test('the joint itself stays where it is', () {
    const joint = Point3(50, 60, 5);
    final transform = _transform(
      'arm',
      {'arm': const PartRig(pivot: joint)},
      {'arm': const PartPose(yaw: 1, pitch: 0.5, roll: -0.7)},
    );
    expect(transform.apply(joint), _near(joint));
  });

  test('a child follows the part it hangs from', () {
    final transform = _transform(
      'hand',
      {
        'arm': const PartRig(pivot: Point3.zero),
        'hand': const PartRig(pivot: Point3(0, 0, 10), parentId: 'arm'),
      },
      {'arm': const PartPose(yaw: _quarterTurn)},
    );
    expect(transform.apply(const Point3(0, 0, 10)), _near(const Point3(10, 0, 0)));
  });

  test('a loop of parents still ends', () {
    final transform = _transform(
      'first',
      {
        'first': const PartRig(pivot: Point3.zero, parentId: 'second'),
        'second': const PartRig(pivot: Point3.zero, parentId: 'first'),
      },
      {
        'first': const PartPose(yaw: 0.1),
        'second': const PartPose(yaw: 0.1),
      },
    );
    expect(transform.apply(const Point3(1, 0, 0)), isA<Point3>());
  });

  test('renaming a part carries its joint, children and poses', () {
    final model = Model3d(
      rigs: {
        'arm': const PartRig(pivot: Point3.zero),
        'hand': const PartRig(pivot: Point3.zero, parentId: 'arm'),
      },
      views: const [
        ViewAngle(
          name: 'view',
          poses: {'arm': PartPose(yaw: 1)},
          hidden: {'arm'},
        ),
      ],
    );
    final renamed = model.renamePart('arm', 'limb');
    expect(renamed.rigs.keys, containsAll(['limb', 'hand']));
    expect(renamed.rigs['hand']!.parentId, 'limb');
    expect(renamed.views.single.poses.keys, ['limb']);
    expect(renamed.views.single.hidden, {'limb'});
  });
}
