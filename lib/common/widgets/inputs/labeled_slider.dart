// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'slider_value_field.dart';

/// A slider with its name above it and a box to type the value into.
/// [onChanged] fires continuously while dragging and once for a typed value;
/// [onChangeEnd] is the moment to record an undo step. Dragging snaps to
/// [step] (0 for none); a typed value is only rounded to [decimals]. The box
/// shows the value times [displayFactor] (100 turns 0..1 into a percentage).
class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    super.key,
    required this.name,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onChangeEnd,
    this.compact = false,
    this.step = 0,
    this.decimals = 1,
    this.unit = '',
    this.displayFactor = 1,
    this.inputMin,
    this.inputMax,
  });

  final String name;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final VoidCallback onChangeEnd;
  final bool compact;
  final double step;
  final int decimals;
  final String unit;
  final double displayFactor;

  /// Limits for typed values, when they may go past the slider's own range.
  final double? inputMin;
  final double? inputMax;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(name, style: TextStyle(fontSize: compact ? 12 : null)),
            ),
            SliderValueField(
              compact: compact,
              value: value * displayFactor,
              decimals: decimals,
              unit: unit,
              onSubmitted: _typed,
            ),
          ],
        ),
        SizedBox(
          height: compact ? 28 : null,
          child: Slider(
            value: value.clamp(min, max).toDouble(),
            min: min,
            max: max,
            onChanged: (dragged) =>
                onChanged(step > 0 ? (dragged / step).round() * step : dragged),
            onChangeEnd: (_) => onChangeEnd(),
          ),
        ),
      ],
    );
  }

  void _typed(double shown) {
    final rounded = double.parse(shown.toStringAsFixed(decimals));
    final typed = rounded / displayFactor;
    onChanged(typed.clamp(inputMin ?? min, inputMax ?? max).toDouble());
    onChangeEnd();
  }
}
