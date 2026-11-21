// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../common/widgets/inputs/labeled_slider.dart';
import '../../../bloc/editor_bloc.dart';

/// A named slider for the 3D panel with a box to type the value. Dragging
/// calls [onChanged] with no undo step; letting go, or typing, records one.
class Model3dSlider extends StatelessWidget {
  const Model3dSlider({
    super.key,
    required this.name,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 0.5,
    this.decimals = 1,
    this.unit = '',
    this.inputMin,
    this.inputMax,
  });

  final String name;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final double step;
  final int decimals;
  final String unit;
  final double? inputMin;
  final double? inputMax;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 260),
    child: LabeledSlider(
      compact: true,
      name: name,
      value: value,
      min: min,
      max: max,
      step: step,
      decimals: decimals,
      unit: unit,
      inputMin: inputMin,
      inputMax: inputMax,
      onChanged: onChanged,
      onChangeEnd: () => context.read<EditorBloc>().add(const ChangesCommitted()),
    ),
  );
}
