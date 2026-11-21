// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../models/model3d/points.dart';
import '../../../models/shapes/shape.dart';
import '../../../models/shapes/shape_kind.dart';
import '../sections/section_depths.dart';
import '../sections/section_surface.dart';
import 'shape_tilt.dart';
import '../transforms/view_transform.dart';

// A turn sharper than this is an edge; a gentler one is part of a curve.
const double _cornerAngle = math.pi / 6;

/// The side walls of a thick shape that face the viewer. Walls along a
/// smooth stretch of the outline, such as a rounded corner, are joined into
/// one piece so they do not show a line for every point of the curve.
List<SurfacePiece> shapeWalls(
  Shape shape,
  List<Offset> outline,
  ({List<Offset> near, List<Offset> far}) faces,
  SectionDepths depths,
  ShapeTilt tilt,
  ViewTransform transform, {
  required bool seamless,
}) {
  final count = outline.length;
  final directions = [
    for (var index = 0; index < count; index++)
      outline[(index + 1) % count] - outline[index],
  ];
  final orientation = _signedArea(outline).sign;
  final visible = [
    for (final direction in directions)
      transform
              .turn(
                tilt.turn(
                  Point3(direction.dy * orientation, -direction.dx * orientation, 0),
                ),
              )
              .dz <
          0,
  ];
  bool breaksBetween(int before, int after) =>
      !visible[before] ||
      !visible[after] ||
      _turnBetween(directions[before], directions[after]) > _cornerAngle;

  var first = 0;
  for (var index = 0; index < count; index++) {
    if (breaksBetween((index + count - 1) % count, index)) {
      first = index;
      break;
    }
  }
  final walls = <SurfacePiece>[];
  var step = 0;
  while (step < count) {
    final start = (first + step) % count;
    step++;
    if (!visible[start]) continue;
    final run = [start];
    while (step < count && !breaksBetween(run.last, (first + step) % count)) {
      run.add((first + step) % count);
      step++;
    }
    walls.add(
      _wall(shape, outline, faces, depths, tilt, transform, [
        ...run,
        (run.last + 1) % count,
      ], walls.length, seamless),
    );
  }
  return walls;
}

SurfacePiece _wall(
  Shape shape,
  List<Offset> outline,
  ({List<Offset> near, List<Offset> far}) faces,
  SectionDepths depths,
  ShapeTilt tilt,
  ViewTransform transform,
  List<int> vertices,
  int number,
  bool seamless,
) {
  var depth = 0.0;
  for (final vertex in vertices) {
    final middle = (depths.near[vertex] + depths.far[vertex]) / 2;
    depth += transform
        .project(
          tilt.apply(Point3(outline[vertex].dx, outline[vertex].dy, middle)),
        )
        .dz;
  }
  return (
    depth: depth / vertices.length,
    shape: Shape(
      kind: ShapeKind.polygon,
      points: [
        for (final vertex in vertices) faces.near[vertex],
        for (final vertex in vertices.reversed) faces.far[vertex],
      ],
      name: '${shape.name}Side${number + 1}',
      fill: shape.fill,
      stroke: seamless ? shape.fill : shape.stroke,
      strokeWidth: seamless ? kSeamWidth : shape.strokeWidth,
      groupId: shape.groupId,
      groupName: shape.groupName,
    ),
  );
}

double _turnBetween(Offset before, Offset after) => math
    .atan2(
      before.dx * after.dy - before.dy * after.dx,
      before.dx * after.dx + before.dy * after.dy,
    )
    .abs();

double _signedArea(List<Offset> outline) {
  var total = 0.0;
  for (var index = 0; index < outline.length; index++) {
    final next = outline[(index + 1) % outline.length];
    total += outline[index].dx * next.dy - next.dx * outline[index].dy;
  }
  return total / 2;
}
