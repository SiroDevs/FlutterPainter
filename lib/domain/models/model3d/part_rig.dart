// Dart imports:
import 'dart:math' as math;

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import 'points.dart';

/// The joint of a part: where it turns, what it hangs from, and how it is
/// folded and bent. A part is a group of shapes.
///
/// - pivot / axisAngle: a point on the fold line, and the direction of the
///   line in the drawing plane (radians; 0 is horizontal).
/// - fold: swings the part around the fold line. Positive folds it away from
///   the viewer, like the sides of a box seen from the front.
/// - bend: curls the part around the fold line over its whole length.
///   Positive curls it away from the viewer.
class PartRig extends Equatable {
  const PartRig({
    required this.pivot,
    this.parentId,
    this.axisAngle = 0,
    this.fold = 0,
    this.bend = 0,
  });

  final Point3 pivot;
  final String? parentId;
  final double axisAngle;
  final double fold;
  final double bend;

  /// The fold line's direction.
  Point3 get axis => Point3(math.cos(axisAngle), math.sin(axisAngle), 0);

  PartRig copyWith({
    Point3? pivot,
    Object? parentId = unset,
    double? axisAngle,
    double? fold,
    double? bend,
  }) => PartRig(
    pivot: pivot ?? this.pivot,
    parentId: keep<String>(parentId, this.parentId),
    axisAngle: axisAngle ?? this.axisAngle,
    fold: fold ?? this.fold,
    bend: bend ?? this.bend,
  );

  @override
  List<Object?> get props => [pivot, parentId, axisAngle, fold, bend];
}
