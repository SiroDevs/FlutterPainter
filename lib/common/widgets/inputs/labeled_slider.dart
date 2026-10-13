// Flutter imports:
import 'package:flutter/material.dart';

/// A slider with its label and value above it. [onChangeEnd] is the moment to
/// record an undo step, since [onChanged] fires continuously while dragging.
class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onChangeEnd,
    this.compact = false,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final VoidCallback onChangeEnd;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: compact ? 12 : null)),
      SizedBox(
        height: compact ? 28 : null,
        child: Slider(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max,
          onChanged: onChanged,
          onChangeEnd: (_) => onChangeEnd(),
        ),
      ),
    ]);
  }
}
