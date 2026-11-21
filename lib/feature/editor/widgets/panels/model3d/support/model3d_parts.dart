// Project imports:
import '../../../../../../domain/models/drawing/paint_layer.dart';
import '../../../../../../domain/models/model3d/model3d.dart';
import '../../../../../../domain/models/model3d/part_pose.dart';
import '../../../../../../domain/models/model3d/part_rig.dart';
import '../../../../../../domain/models/model3d/points.dart';
import '../../../../../../domain/models/shapes/shape.dart';
import 'exports.dart';

/// Changes one value of a joint, given the new angle in radians.
typedef PartRigChange = PartRig Function(PartRig rig, double radians);

/// A part that can move on its own, and where its joint starts out.
typedef PartEntry = ({String id, String name, Point3 pivot});

/// The parts of a 3D layer: its groups, in drawing order.
List<PartEntry> listParts(PaintLayer layer, Model3d model) {
  final groups = <String, List<Shape>>{};
  for (final shape in layer.shapes) {
    final id = shape.groupId;
    if (id != null) groups.putIfAbsent(id, () => []).add(shape);
  }
  return [
    for (final entry in groups.entries)
      (
        id: entry.key,
        name: entry.value.first.groupName ?? entry.key,
        pivot: _centreOf(entry.value),
      ),
  ];
}

Point3 _centreOf(List<Shape> shapes) {
  var bounds = shapes.first.bounds;
  var totalZ = 0.0;
  for (final shape in shapes) {
    bounds = bounds.expandToInclude(shape.bounds);
    totalZ += shape.z;
  }
  return Point3(bounds.center.dx, bounds.center.dy, totalZ / shapes.length);
}

/// The joint of [part]: the saved one, or one at the part's centre.
PartRig rigOf(Model3d model, PartEntry part) =>
    model.rigs[part.id] ?? PartRig(pivot: part.pivot);

/// Changes the joint of [part], saving it if it had none yet.
Model3d withRig(
  Model3d model,
  PartEntry part,
  PartRig Function(PartRig rig) change,
) => model.copyWith(
  rigs: {...model.rigs, part.id: change(rigOf(model, part))},
);

/// Changes how [part] is posed in the view at [viewIndex].
Model3d withPose(
  Model3d model,
  PartEntry part,
  int viewIndex,
  PartPose Function(PartPose pose) change,
) => updateView(
  withRig(model, part, (rig) => rig),
  viewIndex,
  (view) => view.copyWith(
    poses: {
      ...view.poses,
      part.id: change(view.poses[part.id] ?? PartPose.rest),
    },
  ),
);

/// Whether [partId] hangs from [ancestorId], directly or further up.
bool hangsFrom(Model3d model, String partId, String ancestorId) {
  var current = model.rigs[partId]?.parentId;
  for (var step = 0; current != null && step < 16; step++) {
    if (current == ancestorId) return true;
    current = model.rigs[current]?.parentId;
  }
  return false;
}
