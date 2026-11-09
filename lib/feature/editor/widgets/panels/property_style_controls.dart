// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/widgets/inputs/labeled_slider.dart';
import '../../bloc/editor_bloc.dart';
import '../../models/style_settings.dart';

/// Fill, stroke, and stroke-width controls grouped together.
class PropertyStyleControls extends StatelessWidget {
  const PropertyStyleControls({super.key, required this.style});

  final StyleSettings style;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        [
          _toggle(
            'Fill',
            style.fillOn,
            style.fillColor,
            (value) => bloc.add(FillToggled(value)),
            () => bloc.add(const StyleTargetChanged(true)),
          ),
          _toggle(
            'Stroke',
            style.strokeOn,
            style.strokeColor,
            (value) => bloc.add(StrokeToggled(value)),
            () => bloc.add(const StyleTargetChanged(false)),
          ),
        ].toRow(),
        SizedBox(
          width: 190,
          child: LabeledSlider(
            compact: true,
            label: 'Stroke width: ${style.strokeWidth.toStringAsFixed(2)}',
            value: style.strokeWidth,
            min: 0.25,
            max: 20,
            onChanged: (value) =>
                bloc.add(StrokeWidthChanged((value * 4).round() / 4)),
            onChangeEnd: () => bloc.add(const ChangesCommitted()),
          ),
        ),
      ],
    );
  }

  Widget _toggle(
    String label,
    bool on,
    int color,
    ValueChanged<bool> set,
    VoidCallback pick,
  ) => SizedBox(
    width: 150,
    child: Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: on,
          onChanged: (value) => set(value ?? false),
        ),
        Text(label),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: pick,
          child: Container(
            width: 28,
            height: 20,
            decoration: BoxDecoration(
              color: Color(color),
              border: Border.all(color: Colors.white54),
            ),
          ),
        ),
      ],
    ),
  );
}
