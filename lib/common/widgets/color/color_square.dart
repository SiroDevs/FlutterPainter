// Flutter imports:
import 'package:flutter/material.dart';

// A square for saturation (across) and brightness (up) at the hue of [color].
class SaturationValueSquare extends StatelessWidget {
  const SaturationValueSquare({
    super.key,
    required this.color,
    required this.onChanged,
    this.size = 180,
  });

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final double size;

  void _pick(Offset position) {
    final saturation = (position.dx / size).clamp(0.0, 1.0).toDouble();
    final value = (1 - position.dy / size).clamp(0.0, 1.0).toDouble();
    onChanged(color.withSaturation(saturation).withValue(value));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _pick(details.localPosition),
      onPanUpdate: (details) => _pick(details.localPosition),
      onTapDown: (details) => _pick(details.localPosition),
      child: CustomPaint(
        size: Size.square(size),
        painter: _SquarePainter(color),
      ),
    );
  }
}

class _SquarePainter extends CustomPainter {
  const _SquarePainter(this.color);

  final HSVColor color;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final hue = HSVColor.fromAHSV(1, color.hue, 1, 1).toColor();
    final across = LinearGradient(colors: [const Color(0xFFFFFFFF), hue]);
    const up = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x00000000), Color(0xFF000000)],
    );
    canvas
      ..drawRect(bounds, Paint()..shader = across.createShader(bounds))
      ..drawRect(bounds, Paint()..shader = up.createShader(bounds));
    final thumb = Offset(color.saturation * size.width, (1 - color.value) * size.height);
    canvas
      ..drawCircle(
        thumb,
        7,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFF000000),
      )
      ..drawCircle(
        thumb,
        7,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0xFFFFFFFF),
      );
  }

  @override
  bool shouldRepaint(_SquarePainter old) => old.color != color;
}

// A slider that picks the hue of a colour.
class HueSlider extends StatelessWidget {
  const HueSlider({super.key, required this.color, required this.onChanged});

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: color.hue.clamp(0, 359.99).toDouble(),
      min: 0,
      max: 359.99,
      onChanged: (hue) => onChanged(color.withHue(hue)),
    );
  }
}
