// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../models/model3d/points.dart';
import '../../../models/model3d/section_profile.dart';
import '../../../models/shapes/shape.dart';
import '../../../models/shapes/shape_kind.dart';
import 'section_shape.dart';
import '../shapes/shape_tilt.dart';
import '../transforms/view_transform.dart';

/// A flat piece of a projected shape and how far from the viewer it is.
typedef SurfacePiece = ({double depth, Shape shape});

const int _stripCount = 32;
// Thin line in the fill colour that hides gaps between touching pieces.
const double kSeamWidth = 0.4;

/// The curved near and far faces of [shape], cut into strips across its
/// cross-section so each strip shows or hides on its own.
List<SurfacePiece> sectionStrips(
  Shape shape,
  List<Offset> outline,
  ShapeTilt tilt,
  ViewTransform transform,
) {
  final bounds = shape.unrotatedBounds;
  final alongWidth = shape.section.axis == SectionAxis.width;
  final reach = alongWidth ? bounds.width / 2 : bounds.height / 2;
  final direction = Offset.fromDirection(
    shape.rotation + (alongWidth ? 0 : math.pi / 2),
  );
  double across(Offset point) {
    final offset = point - bounds.center;
    return (offset.dx * direction.dx + offset.dy * direction.dy) / reach;
  }

  final section = SectionShape(shape.section);
  final half = shape.thickness / 2;
  final axis = Point3(direction.dx, direction.dy, 0);
  double depthAt(Offset point, bool near) {
    final range = section.rangeAt(across(point));
    return shape.z + (near ? range.near : range.far) * half;
  }

  final pieces = <SurfacePiece>[];
  for (var strip = 0; strip < _stripCount; strip++) {
    final start = -1 + 2 * strip / _stripCount;
    final end = -1 + 2 * (strip + 1) / _stripCount;
    final cut = _between(outline, across, start, end);
    if (cut.length < 3) continue;
    final first = section.rangeAt(start);
    final last = section.rangeAt(end);
    final length = (end - start) * reach;
    final nearSlope = (last.near - first.near) * half / length;
    final farSlope = (last.far - first.far) * half / length;
    final centre =
        cut.reduce((total, point) => total + point) / cut.length.toDouble();
    for (final near in const [true, false]) {
      final normal = near
          ? axis * nearSlope + const Point3(0, 0, -1)
          : axis * -farSlope + const Point3(0, 0, 1);
      if (transform.turn(tilt.turn(normal)).dz >= 0) continue;
      pieces.add((
        depth: transform
            .project(
              tilt.apply(Point3(centre.dx, centre.dy, depthAt(centre, near))),
            )
            .dz,
        shape: Shape(
          kind: ShapeKind.polygon,
          points: [
            for (final point in cut)
              transform.flat(
                tilt.apply(Point3(point.dx, point.dy, depthAt(point, near))),
              ),
          ],
          name: '${shape.name}Surface${strip + 1}${near ? 'Near' : 'Far'}',
          fill: shape.fill,
          stroke: shape.stroke ?? shape.fill,
          strokeWidth: shape.stroke == null ? kSeamWidth : shape.strokeWidth,
          groupId: shape.groupId,
          groupName: shape.groupName,
        ),
      ));
    }
  }
  return pieces;
}

List<Offset> _between(
  List<Offset> outline,
  double Function(Offset point) across,
  double start,
  double end,
) => _clip(
  _clip(outline, (point) => across(point) - start),
  (point) => end - across(point),
);

// Keeps the part of a closed polygon where [margin] is not negative.
List<Offset> _clip(List<Offset> polygon, double Function(Offset) margin) {
  final kept = <Offset>[];
  for (var index = 0; index < polygon.length; index++) {
    final current = polygon[index];
    final previous = polygon[(index + polygon.length - 1) % polygon.length];
    final currentMargin = margin(current);
    final previousMargin = margin(previous);
    if ((currentMargin >= 0) != (previousMargin >= 0)) {
      final fraction = previousMargin / (previousMargin - currentMargin);
      kept.add(Offset.lerp(previous, current, fraction)!);
    }
    if (currentMargin >= 0) kept.add(current);
  }
  return kept;
}
