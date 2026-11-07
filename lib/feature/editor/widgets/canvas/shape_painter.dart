// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/services/rendering/gradient_shader.dart';
import '../../../../domain/services/geometry/shape_geometry.dart';

/// Draws one [Shape] on a canvas: fill first, then stroke.
void paintShape(Canvas canvas, Shape shape, Paint paint) {
  final center = shape.unrotatedBounds.center;
  canvas.save();
  canvas.translate(center.dx, center.dy);
  canvas.rotate(shape.rotation);
  canvas.translate(-center.dx, -center.dy);
  final path = shape.buildPath();
  final fill = shape.fill;
  if (shape.isClosed && fill != null) {
    final gradient = shape.gradient;
    paint
      ..style = PaintingStyle.fill
      ..color = Color(fill)
      ..shader = gradient == null
          ? null
          : gradientShader(gradient, shape.unrotatedBounds);
    canvas.drawPath(path, paint);
    paint.shader = null;
  }
  final stroke = shape.stroke;
  if (stroke != null) {
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = shape.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Color(stroke);
    canvas.drawPath(path, paint);
  }
  canvas.restore();
}
