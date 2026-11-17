// Dart imports:
import 'dart:ui';

// Project imports:
import '../../models/model3d/point3.dart';
import '../../models/shapes/shape.dart';
import '../../models/shapes/shape_kind.dart';
import 'shape_outline.dart';
import 'view_transform.dart';

typedef _Side = ({double depth, Shape shape});

/// Projects one drawn shape: its visible sides first, then its face.
List<Shape> projectShape(Shape shape, ViewTransform transform) {
  final outline = outlineOf(shape);
  if (outline.length < 2) return const [];
  final half = shape.thickness / 2;
  final nearFace = _place(outline, shape.depth - half, transform);
  if (!shape.isClosed || shape.thickness <= 0) {
    return [_face(shape, nearFace)];
  }
  final farFace = _place(outline, shape.depth + half, transform);
  // A part turned past the side shows its back cap instead of its front.
  final showsNear = transform.turn(const Point3(0, 0, -1)).dz <= 0;
  return [
    ..._sides(shape, outline, nearFace, farFace, transform),
    _face(shape, showsNear ? nearFace : farFace),
  ];
}

Shape _face(Shape shape, List<Offset> points) => shape.copyWith(
  kind: shape.isClosed ? ShapeKind.polygon : shape.kind,
  points: points,
  rotation: 0,
  radius: 0,
  depth: 0,
  thickness: 0,
);

List<Offset> _place(List<Offset> outline, double depth, ViewTransform view) => [
  for (final point in outline) view.flat(Point3(point.dx, point.dy, depth)),
];

List<Shape> _sides(
  Shape shape,
  List<Offset> outline,
  List<Offset> nearFace,
  List<Offset> farFace,
  ViewTransform transform,
) {
  final orientation = _signedArea(outline).sign;
  final sides = <_Side>[];
  for (var index = 0; index < outline.length; index++) {
    final next = (index + 1) % outline.length;
    final edge = outline[next] - outline[index];
    final outward = Point3(edge.dy * orientation, -edge.dx * orientation, 0);
    if (transform.turn(outward).dz >= 0) continue;
    final middle = (outline[index] + outline[next]) / 2;
    sides.add((
      depth: transform.project(Point3(middle.dx, middle.dy, shape.depth)).dz,
      shape: Shape(
        kind: ShapeKind.polygon,
        points: [
          nearFace[index],
          nearFace[next],
          farFace[next],
          farFace[index],
        ],
        name: '${shape.name}Side${index + 1}',
        fill: shape.fill,
        stroke: shape.stroke,
        strokeWidth: shape.strokeWidth,
        groupId: shape.groupId,
        groupName: shape.groupName,
      ),
    ));
  }
  sides.sort((first, second) => second.depth.compareTo(first.depth));
  return [for (final side in sides) side.shape];
}

double _signedArea(List<Offset> outline) {
  var total = 0.0;
  for (var index = 0; index < outline.length; index++) {
    final next = outline[(index + 1) % outline.length];
    total += outline[index].dx * next.dy - next.dx * outline[index].dy;
  }
  return total / 2;
}
