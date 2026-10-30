// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/widgets/color/color_square.dart';
import '../../../../common/widgets/color/color_wheel.dart';
import '../../../../common/widgets/color/gradient_editor.dart';
import '../../../../common/widgets/color/hex_code_field.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/shape_gradient.dart';

// What the color picker hands back: a flat color, or a gradient when one is set
// (then [color] is its first stop).
class ColorPickerResult {
  const ColorPickerResult({required this.color, this.gradient});

  final int color;
  final ShapeGradient? gradient;
}

// A color picker with a wheel or a square, brightness, opacity, a hex code and,
// for fills, gradients. In gradient mode the picker edits the selected stop.
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    this.initialGradient,
    this.allowGradient = true,
  });

  final int initialColor;
  final ShapeGradient? initialGradient;
  final bool allowGradient;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late int _solid = widget.initialColor;
  late ShapeGradient? _gradient = widget.initialGradient;
  late HSVColor _hsv = HSVColor.fromColor(Color(_current));
  int _stop = 0;
  bool _wheel = true;

  bool get _useGradient => _gradient != null;

  int get _current => _gradient?.colors[_stop] ?? _solid;

  void _setColor(int argb) {
    final gradient = _gradient;
    if (gradient == null) {
      _solid = argb;
      return;
    }
    _gradient = gradient.copyWith(colors: [...gradient.colors]..[_stop] = argb);
  }

  void _pickHsv(HSVColor hsv) => setState(() {
        _hsv = hsv;
        _setColor(hsv.toColor().toARGB32());
      });

  void _typeHex(int argb) => setState(() {
        _hsv = HSVColor.fromColor(Color(argb));
        _setColor(argb);
      });

  void _selectStop(int index) => setState(() {
        _stop = index;
        _hsv = HSVColor.fromColor(Color(_current));
      });

  void _setGradientMode(bool useGradient) => setState(() {
        if (useGradient) {
          final darker = _hsv.withValue(_hsv.value * 0.5).toColor().toARGB32();
          _gradient = ShapeGradient.initial(GradientKind.linear, _solid, darker);
        } else {
          _solid = _gradient?.firstColor ?? _solid;
          _gradient = null;
        }
        _stop = 0;
        _hsv = HSVColor.fromColor(Color(_current));
      });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      shape: const RoundedRectangleBorder(),
      title: Text(l10n.colorPickerTitle),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (widget.allowGradient) ..._modeToggle(context),
            if (_gradient != null) ...[
              GradientEditor(
                gradient: _gradient!,
                selectedStop: _stop,
                onChanged: (gradient) => setState(() => _gradient = gradient),
                onStopSelected: _selectStop,
              ),
              const SizedBox(height: 12),
            ],
            _pickerToggle(context),
            const SizedBox(height: 12),
            Center(child: _picker(context)),
            _slider(l10n.colorOpacity, _hsv.alpha, (v) => _pickHsv(_hsv.withAlpha(v))),
            const SizedBox(height: 8),
            HexCodeField(
              argb: _current,
              label: l10n.colorHexCode,
              onChanged: _typeHex,
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(shape: const RoundedRectangleBorder()),
          onPressed: () => Navigator.pop(
            context,
            ColorPickerResult(
              color: _gradient?.firstColor ?? _solid,
              gradient: _gradient,
            ),
          ),
          child: Text(l10n.apply),
        ),
      ],
    );
  }

  List<Widget> _modeToggle(BuildContext context) => [
        SegmentedButton<bool>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(shape: const RoundedRectangleBorder()),
          segments: [
            ButtonSegment(value: false, label: Text(context.l10n.colorSolid)),
            ButtonSegment(value: true, label: Text(context.l10n.colorGradient)),
          ],
          selected: {_useGradient},
          onSelectionChanged: (modes) => _setGradientMode(modes.first),
        ),
        const SizedBox(height: 12),
      ];

  Widget _pickerToggle(BuildContext context) => SegmentedButton<bool>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(shape: const RoundedRectangleBorder()),
        segments: [
          ButtonSegment(value: true, label: Text(context.l10n.colorWheel)),
          ButtonSegment(value: false, label: Text(context.l10n.colorSquare)),
        ],
        selected: {_wheel},
        onSelectionChanged: (modes) => setState(() => _wheel = modes.first),
      );

  Widget _picker(BuildContext context) {
    if (_wheel) {
      return Column(children: [
        ColorWheel(color: _hsv, onChanged: _pickHsv),
        _slider(context.l10n.colorBrightness, _hsv.value, (v) => _pickHsv(_hsv.withValue(v))),
      ]);
    }
    return Column(children: [
      SaturationValueSquare(color: _hsv, onChanged: _pickHsv),
      HueSlider(color: _hsv, onChanged: _pickHsv),
    ]);
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) =>
      Row(children: [
        SizedBox(width: 84, child: Text(label)),
        Expanded(child: Slider(value: value.clamp(0.0, 1.0).toDouble(), onChanged: onChanged)),
      ]);
}
