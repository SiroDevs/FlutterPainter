// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'part_rig.dart';
import 'point3.dart';
import 'view_angle.dart';

/// The 3D setup of a layer. The layer's shapes are the object drawn flat;
/// this adds where it turns, its named views, and the joints (by part id)
/// that fold, bend and pose its parts.
class Model3d extends Equatable {
  const Model3d({
    this.pivot = const Point3(60, 166, 0),
    this.views = const [],
    this.rigs = const {},
  });

  final Point3 pivot;
  final List<ViewAngle> views;
  final Map<String, PartRig> rigs;

  Model3d copyWith({
    Point3? pivot,
    List<ViewAngle>? views,
    Map<String, PartRig>? rigs,
  }) => Model3d(
    pivot: pivot ?? this.pivot,
    views: views ?? this.views,
    rigs: rigs ?? this.rigs,
  );

  /// Gives a part a new id, carrying its joint, children and poses with it.
  Model3d renamePart(String from, String to) {
    if (from == to) return this;
    String? moved(String? id) => id == from ? to : id;
    return copyWith(
      rigs: {
        for (final entry in rigs.entries)
          moved(entry.key)!: entry.value.copyWith(
            parentId: moved(entry.value.parentId),
          ),
      },
      views: [
        for (final view in views)
          view.copyWith(
            poses: {
              for (final entry in view.poses.entries)
                moved(entry.key)!: entry.value,
            },
            hidden: {for (final id in view.hidden) moved(id)!},
          ),
      ],
    );
  }

  @override
  List<Object?> get props => [pivot, views, rigs];
}
