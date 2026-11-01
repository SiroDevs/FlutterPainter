// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// A hue and saturation wheel. Hue follows the angle and saturation the
// distance from the centre; the brightness comes from [color] and is shown by
// darkening the wheel.
class ColorWheel extends StatelessWidget {
  const ColorWheel({
    super.key,
    required this.color,
    required this.onChanged,
    this.diameter = 180,
  });

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final double diameter;

  void _pick(Offset position) {
    final radius = diameter / 2;
    final delta = position - Offset(radius, radius);
    final hue = (math.atan2(delta.dy, delta.dx) * 180 / math.pi + 360) % 360;
    final saturation = (delta.distance / radius).clamp(0.0, 1.0).toDouble();
    onChanged(color.withHue(hue).withSaturation(saturation));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _pick(details.localPosition),
      onPanUpdate: (details) => _pick(details.localPosition),
      onTapDown: (details) => _pick(details.localPosition),
      child: CustomPaint(
        size: Size.square(diameter),
        painter: _WheelPainter(color),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  const _WheelPainter(this.color);

  final HSVColor color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    final hues = SweepGradient(colors: [
      for (var degrees = 0; degrees <= 360; degrees += 60)
        HSVColor.fromAHSV(1, (degrees % 360).toDouble(), 1, 1).toColor(),
    ]);
    const fade = RadialGradient(colors: [Color(0xFFFFFFFF), Color(0x00FFFFFF)]);
    canvas
      ..drawCircle(center, radius, Paint()..shader = hues.createShader(bounds))
      ..drawCircle(center, radius, Paint()..shader = fade.createShader(bounds))
      ..drawCircle(
        center,
        radius,
        Paint()..color = Color.fromRGBO(0, 0, 0, 1 - color.value),
      );
    final angle = color.hue * math.pi / 180;
    final thumb = center +
        Offset(math.cos(angle), math.sin(angle)) * (color.saturation * radius);
    canvas
      ..drawCircle(
        thumb,
        8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFF000000),
      )
      ..drawCircle(
        thumb,
        8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0xFFFFFFFF),
      );
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.color != color;
}
