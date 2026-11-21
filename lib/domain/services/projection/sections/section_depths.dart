// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../models/model3d/section_profile.dart';
import '../../../models/shapes/shape.dart';
import 'section_shape.dart';

typedef SectionDepths = ({List<double> near, List<double> far});

/// The near and far depth of every point of [outline], following the
/// cross-section of [shape]. A box reaches the same distance everywhere.
SectionDepths sectionDepths(Shape shape, List<Offset> outline) {
  final half = shape.thickness / 2;
  final bounds = shape.unrotatedBounds;
  final reach = shape.section.axis == SectionAxis.width
      ? bounds.width / 2
      : bounds.height / 2;
  if (shape.section.isBox || shape.thickness <= 0 || reach < 1e-9) {
    return (
      near: List.filled(outline.length, shape.z - half),
      far: List.filled(outline.length, shape.z + half),
    );
  }
  final section = SectionShape(shape.section);
  final centre = bounds.center;
  final near = <double>[];
  final far = <double>[];
  for (final point in outline) {
    final local = shape.rotation == 0
        ? point
        : Shape.rotatePoint(point, -shape.rotation, centre);
    final across = shape.section.axis == SectionAxis.width
        ? (local.dx - centre.dx) / reach
        : (local.dy - centre.dy) / reach;
    final range = section.rangeAt(across);
    near.add(shape.z + range.near * half);
    far.add(shape.z + range.far * half);
  }
  return (near: near, far: far);
}
