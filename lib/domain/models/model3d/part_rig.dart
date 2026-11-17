// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import 'point3.dart';

/// The joint of a part: where it turns, and the part it hangs from. A part
/// is a group of shapes, or a tyre, and it follows its parent's movement.
class PartRig extends Equatable {
  const PartRig({required this.pivot, this.parentId});

  final Point3 pivot;
  final String? parentId;

  PartRig copyWith({Point3? pivot, Object? parentId = unset}) => PartRig(
    pivot: pivot ?? this.pivot,
    parentId: keep<String>(parentId, this.parentId),
  );

  @override
  List<Object?> get props => [pivot, parentId];
}
