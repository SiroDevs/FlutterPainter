// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../common/widgets/inputs/item_chip_row.dart';
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/model3d/model3d.dart';
import '../../../../../domain/models/model3d/part_pose.dart';
import '../../../../../domain/models/model3d/points.dart';
import '../../../../../domain/models/shapes/shape.dart';
import 'model3d_edits.dart';
import 'model3d_fold_controls.dart';
import 'model3d_parent_picker.dart';
import 'model3d_part_visibility.dart';
import 'model3d_parts.dart';
import 'model3d_slider.dart';

/// Lets a part move on its own: where its joint is, what it hangs from, and
/// how it is posed in the selected view.
class Model3dPartsSection extends StatelessWidget {
  const Model3dPartsSection({
    super.key,
    required this.model,
    required this.parts,
    required this.shapes,
    required this.workingPart,
    required this.selected,
    required this.viewIndex,
    required this.canvasSize,
    required this.onSelected,
  });

  final Model3d model;
  final List<PartEntry> parts;
  final List<Shape> shapes;
  final String? workingPart;
  final int selected;
  final int viewIndex;
  final Size canvasSize;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final part = parts.isEmpty ? null : parts[selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model3dParts,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        if (part == null)
          Text(
            context.l10n.model3dPartsNone,
            style: Theme.of(context).textTheme.bodySmall,
          )
        else ...[
          ItemChipRow(
            labels: [for (final item in parts) item.name],
            selected: selected,
            onSelected: onSelected,
          ),
          ..._joint(context, part),
          Model3dParentPicker(model: model, part: part, parts: parts),
          Model3dFoldControls(
            model: model,
            part: part,
            shapes: shapes,
            workingPart: workingPart,
            faceNumber: parts.length + 1,
          ),
          ..._pose(context, part),
        ],
      ],
    );
  }

  List<Widget> _joint(BuildContext context, PartEntry part) {
    final pivot = rigOf(model, part).pivot;
    return [
      Text(
        context.l10n.model3dPartJoint,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      _jointSlider(
        context,
        part,
        context.l10n.model3dAxisX,
        pivot.dx,
        0,
        canvasSize.width,
        (next) => Point3(next, pivot.dy, pivot.dz),
      ),
      _jointSlider(
        context,
        part,
        context.l10n.model3dAxisY,
        pivot.dy,
        0,
        canvasSize.height,
        (next) => Point3(pivot.dx, next, pivot.dz),
      ),
      _jointSlider(
        context,
        part,
        context.l10n.model3dAxisZ,
        pivot.dz,
        -kZSliderRange,
        kZSliderRange,
        (next) => Point3(pivot.dx, pivot.dy, next),
        inputLimit: kZRange,
      ),
    ];
  }

  Widget _jointSlider(
    BuildContext context,
    PartEntry part,
    String name,
    double value,
    double min,
    double max,
    Point3 Function(double next) moved, {
    double? inputLimit,
  }) => Model3dSlider(
    name: name,
    value: value,
    min: min,
    max: max,
    inputMin: inputLimit == null ? null : -inputLimit,
    inputMax: inputLimit,
    onChanged: (next) => editModel(
      context,
      (current) => withRig(
        current,
        part,
        (rig) => rig.copyWith(pivot: moved(next)),
      ),
      record: false,
    ),
  );

  List<Widget> _pose(BuildContext context, PartEntry part) {
    if (viewIndex < 0 || viewIndex >= model.views.length) return const [];
    final view = model.views[viewIndex];
    final pose = view.poses[part.id] ?? PartPose.rest;
    return [
      Model3dPartVisibility(part: part, view: view, viewIndex: viewIndex),
      Text(
        context.l10n.model3dPartPose(view.name),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      _poseSlider(
        context,
        part,
        context.l10n.model3dTurn,
        pose.yaw,
        (current, radians) => current.copyWith(yaw: radians),
      ),
      _poseSlider(
        context,
        part,
        context.l10n.model3dTilt,
        pose.pitch,
        (current, radians) => current.copyWith(pitch: radians),
      ),
      _poseSlider(
        context,
        part,
        context.l10n.model3dLean,
        pose.roll,
        (current, radians) => current.copyWith(roll: radians),
      ),
    ];
  }

  Widget _poseSlider(
    BuildContext context,
    PartEntry part,
    String name,
    double radians,
    PartPose Function(PartPose pose, double radians) apply,
  ) => Model3dSlider(
    name: name,
    unit: '°',
    value: degreesOf(radians),
    min: -180,
    max: 180,
    onChanged: (next) => editModel(
      context,
      (current) => withPose(
        current,
        part,
        viewIndex,
        (pose) => apply(pose, radiansOf(next)),
      ),
      record: false,
    ),
  );
}
