// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../models/model3d/part_pose.dart';
import '../../models/model3d/points.dart';
import '../../models/model3d/section_profile.dart';
import '../../models/shapes/shape.dart';
import '../../models/shapes/shape_kind.dart';
import 'section_depths.dart';
import 'section_surface.dart';
import 'shape_outline.dart';
import 'shape_tilt.dart';
import 'shape_walls.dart';
import 'view_transform.dart';

const double _sectionSteps = 40;

/// Projects one drawn shape: its visible sides first, then its face.
List<Shape> projectShape(Shape shape, ViewTransform transform) {
  final tilt = ShapeTilt.of(shape);
  final shaped =
      shape.isClosed && shape.thickness > 0 && !shape.section.isBox;
  final drawn = outlineOf(shape);
  final outline = transform.part.bends || shaped
      ? densify(
          drawn,
          closed: shape.isClosed,
          maxSegment: shaped ? _sectionSegment(shape) : 3,
        )
      : drawn;
  if (outline.length < 2) return const [];
  final depths = sectionDepths(shape, outline);
  final nearFace = _place(outline, depths.near, tilt, transform);
  if (!shape.isClosed || shape.thickness <= 0) {
    return [_face(shape, nearFace)];
  }
  final farFace = _place(outline, depths.far, tilt, transform);
  // A curved form shows parts of both faces, so each face is cut in strips.
  final curved = shaped && shape.fill != null;
  final walls = shapeWalls(
    shape,
    outline,
    (near: nearFace, far: farFace),
    depths,
    tilt,
    transform,
    seamless: curved,
  );
  if (curved) {
    final pieces = [
      ...walls,
      ...sectionStrips(shape, outline, tilt, transform),
    ]..sort(_farthestFirst);
    return [for (final piece in pieces) piece.shape];
  }
  walls.sort(_farthestFirst);
  // A part turned past the side shows its back cap instead of its front.
  final showsNear =
      transform.turn(tilt.turn(const Point3(0, 0, -1))).dz <= 0;
  return [
    for (final wall in walls) wall.shape,
    _face(shape, showsNear ? nearFace : farFace),
  ];
}

int _farthestFirst(SurfacePiece first, SurfacePiece second) =>
    second.depth.compareTo(first.depth);

double _sectionSegment(Shape shape) {
  final bounds = shape.unrotatedBounds;
  return math.max(1.0, math.max(bounds.width, bounds.height) / _sectionSteps);
}

Shape _face(Shape shape, List<Offset> points) => shape.copyWith(
  kind: shape.isClosed ? ShapeKind.polygon : shape.kind,
  points: points,
  rotation: 0,
  radius: 0,
  z: 0,
  thickness: 0,
  tilt: PartPose.rest,
  section: SectionProfile.box,
);

List<Offset> _place(
  List<Offset> outline,
  List<double> depths,
  ShapeTilt tilt,
  ViewTransform view,
) => [
  for (var index = 0; index < outline.length; index++)
    view.flat(
      tilt.apply(Point3(outline[index].dx, outline[index].dy, depths[index])),
    ),
];
