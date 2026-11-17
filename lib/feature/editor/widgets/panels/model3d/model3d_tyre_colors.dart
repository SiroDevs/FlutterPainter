// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../common/widgets/color/color_swatch_button.dart';
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/model3d/tyre_style.dart';
import '../../../../../domain/models/shapes/shape_gradient.dart';
import '../../toolbar/color_picker_dialog.dart';

/// The four colours of a tyre. Tapping one opens the colour picker.
class Model3dTyreColors extends StatelessWidget {
  const Model3dTyreColors({
    super.key,
    required this.style,
    required this.onChanged,
  });

  final TyreStyle style;
  final ValueChanged<TyreStyle> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 14,
    children: [
      _swatch(
        context,
        context.l10n.model3dColorBody,
        style.bodyFill,
        null,
        (result) => style.copyWith(bodyFill: result.color),
      ),
      _swatch(
        context,
        context.l10n.model3dColorTread,
        style.treadStroke ?? style.bodyFill,
        null,
        (result) => style.copyWith(treadStroke: result.color),
      ),
      _swatch(
        context,
        context.l10n.model3dColorSidewall,
        style.sidewallFill,
        style.sidewallGradient,
        (result) => style.copyWith(
          sidewallFill: result.color,
          sidewallGradient: result.gradient,
        ),
        allowGradient: true,
      ),
      _swatch(
        context,
        context.l10n.model3dColorHub,
        style.hubFill,
        style.hubGradient,
        (result) => style.copyWith(
          hubFill: result.color,
          hubGradient: result.gradient,
        ),
        allowGradient: true,
      ),
    ],
  );

  Widget _swatch(
    BuildContext context,
    String label,
    int color,
    ShapeGradient? gradient,
    TyreStyle Function(ColorPickerResult result) apply, {
    bool allowGradient = false,
  }) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ColorSwatchButton(
        color: Color(color),
        onTap: () async {
          final result = await showDialog<ColorPickerResult>(
            context: context,
            builder: (_) => ColorPickerDialog(
              initialColor: color,
              initialGradient: gradient,
              allowGradient: allowGradient,
            ),
          );
          if (result != null) onChanged(apply(result));
        },
      ),
      Text(label, style: const TextStyle(fontSize: 11)),
    ],
  );
}
