// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import '../../../domain/models/shape_gradient.dart';

// Edits everything about a gradient except the colour of its stops, which the
// colour picker next to it edits for the selected stop: the kind, the stops
// (add, remove, move), the angle of a linear gradient and the radius of a
// radial one.
class GradientEditor extends StatelessWidget {
  const GradientEditor({
    super.key,
    required this.gradient,
    required this.selectedStop,
    required this.onChanged,
    required this.onStopSelected,
  });

  final ShapeGradient gradient;
  final int selectedStop;
  final ValueChanged<ShapeGradient> onChanged;
  final ValueChanged<int> onStopSelected;

  static const double _barHeight = 28;
  static const double _markerSize = 16;

  List<Color> get _colors => [for (final argb in gradient.colors) Color(argb)];

  void _moveStop(double position) {
    final low = selectedStop > 0 ? gradient.stops[selectedStop - 1] : 0.0;
    final last = gradient.stops.length - 1;
    final high = selectedStop < last ? gradient.stops[selectedStop + 1] : 1.0;
    final stops = [...gradient.stops];
    stops[selectedStop] = position.clamp(low, high).toDouble();
    onChanged(gradient.copyWith(stops: stops));
  }

  void _addStop() {
    final neighbour = selectedStop + 1 < gradient.stops.length
        ? selectedStop + 1
        : selectedStop - 1;
    final before = neighbour < selectedStop ? neighbour : selectedStop;
    final after = before + 1;
    final color = Color.lerp(_colors[before], _colors[after], 0.5)!.toARGB32();
    final position = (gradient.stops[before] + gradient.stops[after]) / 2;
    onChanged(gradient.copyWith(
      colors: [...gradient.colors]..insert(after, color),
      stops: [...gradient.stops]..insert(after, position),
    ));
    onStopSelected(after);
  }

  void _removeStop() {
    if (gradient.colors.length <= 2) return;
    onChanged(gradient.copyWith(
      colors: [...gradient.colors]..removeAt(selectedStop),
      stops: [...gradient.stops]..removeAt(selectedStop),
    ));
    onStopSelected((selectedStop - 1).clamp(0, gradient.colors.length - 2).toInt());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SegmentedButton<GradientKind>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(shape: const RoundedRectangleBorder()),
        segments: [
          ButtonSegment(value: GradientKind.linear, label: Text(l10n.gradientLinear)),
          ButtonSegment(value: GradientKind.radial, label: Text(l10n.gradientRadial)),
          ButtonSegment(value: GradientKind.sweep, label: Text(l10n.gradientSweep)),
        ],
        selected: {gradient.kind},
        onSelectionChanged: (kinds) => onChanged(gradient.withKind(kinds.first)),
      ),
      const SizedBox(height: 12),
      _stopBar(context),
      Row(children: [
        Text(l10n.gradientStopPosition),
        Slider(
          value: gradient.stops[selectedStop],
          onChanged: _moveStop,
        ).expanded(),
        IconButton(
          tooltip: l10n.gradientAddStop,
          icon: const Icon(Icons.add),
          onPressed: _addStop,
        ),
        IconButton(
          tooltip: l10n.gradientRemoveStop,
          icon: const Icon(Icons.remove),
          onPressed: gradient.colors.length > 2 ? _removeStop : null,
        ),
      ]),
      if (gradient.kind == GradientKind.linear) _angleSlider(context),
      if (gradient.kind == GradientKind.radial) _radiusSlider(context),
    ]);
  }

  Widget _stopBar(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    final accent = Theme.of(context).colorScheme.primary;
    return LayoutBuilder(builder: (context, constraints) {
      final track = constraints.maxWidth - _markerSize;
      return SizedBox(
        height: _barHeight + _markerSize,
        child: Stack(children: [
          Positioned(
            left: _markerSize / 2,
            right: _markerSize / 2,
            top: 0,
            height: _barHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: outline),
                gradient: LinearGradient(colors: _colors, stops: gradient.stops),
              ),
            ),
          ),
          for (var index = 0; index < gradient.colors.length; index++)
            Positioned(
              left: gradient.stops[index] * track,
              top: _barHeight,
              child: GestureDetector(
                onTap: () => onStopSelected(index),
                child: Container(
                  width: _markerSize,
                  height: _markerSize,
                  decoration: BoxDecoration(
                    color: _colors[index],
                    border: Border.all(
                      color: index == selectedStop ? accent : outline,
                      width: index == selectedStop ? 3 : 1,
                    ),
                  ),
                ),
              ),
            ),
        ]),
      );
    });
  }

  Widget _angleSlider(BuildContext context) {
    final degrees = (gradient.angleDegrees + 360) % 360;
    return Row(children: [
      Text(context.l10n.gradientAngle),
      Slider(
        value: degrees,
        max: 360,
        divisions: 72,
        label: '${degrees.round()}°',
        onChanged: (value) => onChanged(gradient.withAngle(value)),
      ).expanded(),
    ]);
  }

  Widget _radiusSlider(BuildContext context) => Row(children: [
        Text(context.l10n.gradientRadius),
        Slider(
          value: gradient.radius.clamp(0.1, 1.0).toDouble(),
          min: 0.1,
          max: 1,
          onChanged: (value) => onChanged(gradient.copyWith(radius: value)),
        ).expanded(),
      ]);
}
