// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../../common/widgets/inputs/item_chip_row.dart';
import '../../../../../../core/utils/l10n_ext.dart';
import '../../../../../../domain/models/model3d/part_pose.dart';
import '../../../../../../domain/models/model3d/section_profile.dart';
import '../../../../../../domain/models/shapes/shape.dart';
import '../../../../bloc/controller/editor_bloc.dart';
import '../support/model3d_edits.dart';
import '../controls/model3d_slider.dart';

const double _angleRange = 180;

/// Cross-section and tilt of the selected shapes. Both show in 3D only.
class Model3dFormSection extends StatelessWidget {
  const Model3dFormSection({super.key, required this.shape});

  final Shape? shape;

  @override
  Widget build(BuildContext context) {
    final current = shape;
    if (current == null) return const SizedBox.shrink();
    final section = current.section;
    final labels = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labels.model3dForm, style: Theme.of(context).textTheme.labelLarge),
        ItemChipRow(
          labels: [
            labels.model3dSectionBox,
            labels.model3dSectionEllipse,
            labels.model3dSectionPolygon,
          ],
          selected: section.kind.index,
          onSelected: (index) => _changeSection(
            context,
            (item) => item.copyWith(kind: SectionKind.values[index]),
          ),
        ),
        if (!section.isBox) ..._sectionControls(context, section),
        if (current.thickness <= 0)
          Text(
            labels.model3dFormThicknessNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        const SizedBox(height: 8),
        Text(
          labels.model3dShapeTilt,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        _tiltSlider(
          context,
          labels.model3dTurn,
          current.tilt.yaw,
          (pose, radians) => pose.copyWith(yaw: radians),
        ),
        _tiltSlider(
          context,
          labels.model3dTilt,
          current.tilt.pitch,
          (pose, radians) => pose.copyWith(pitch: radians),
        ),
        _tiltSlider(
          context,
          labels.model3dLean,
          current.tilt.roll,
          (pose, radians) => pose.copyWith(roll: radians),
        ),
      ],
    );
  }

  List<Widget> _sectionControls(BuildContext context, SectionProfile section) => [
    ItemChipRow(
      labels: [
        context.l10n.model3dSectionAcrossWidth,
        context.l10n.model3dSectionAcrossHeight,
      ],
      selected: section.axis.index,
      onSelected: (index) => _changeSection(
        context,
        (item) => item.copyWith(axis: SectionAxis.values[index]),
      ),
    ),
    if (section.kind == SectionKind.polygon)
      Model3dSlider(
        name: context.l10n.model3dSectionSides,
        step: 1,
        decimals: 0,
        value: section.sides.toDouble(),
        min: SectionProfile.minSides.toDouble(),
        max: SectionProfile.maxSides.toDouble(),
        onChanged: (next) => context.read<EditorBloc>().add(
          ShapeSectionChanged((item) => item.copyWith(sides: next.round())),
        ),
      ),
  ];

  Widget _tiltSlider(
    BuildContext context,
    String name,
    double radians,
    PartPose Function(PartPose pose, double radians) change,
  ) => Model3dSlider(
    name: name,
    unit: '°',
    step: 1,
    decimals: 0,
    value: degreesOf(radians).clamp(-_angleRange, _angleRange).toDouble(),
    min: -_angleRange,
    max: _angleRange,
    onChanged: (next) => context.read<EditorBloc>().add(
      ShapeTiltChanged((pose) => change(pose, radiansOf(next))),
    ),
  );

  void _changeSection(
    BuildContext context,
    SectionProfile Function(SectionProfile section) change,
  ) => context.read<EditorBloc>()
    ..add(ShapeSectionChanged(change))
    ..add(const ChangesCommitted());
}
