// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../common/widgets/inputs/labeled_slider.dart';
import '../../../../../core/utils/l10n_ext.dart';
import '../../../bloc/editor_bloc.dart';

/// A named slider for the 3D panel. Dragging calls [onChanged] with no undo
/// step; letting go records one.
class Model3dSlider extends StatelessWidget {
  const Model3dSlider({
    super.key,
    required this.name,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String name;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 260,
    child: LabeledSlider(
      compact: true,
      label: context.l10n.model3dValue(name, valueText),
      value: value,
      min: min,
      max: max,
      onChanged: onChanged,
      onChangeEnd: () => context.read<EditorBloc>().add(const ChangesCommitted()),
    ),
  );
}
