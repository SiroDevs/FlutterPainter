// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/shape.dart';
import '../../../../domain/services/shape_geometry.dart';

/// Draws one [Shape] on a canvas: fill first, then stroke.
void paintShape(Canvas canvas, Shape shape, Paint paint) {
  final path = shape.buildPath();
  final fill = shape.fill;
  if (shape.isClosed && fill != null) {
    paint
      ..style = PaintingStyle.fill
      ..color = Color(fill);
    canvas.drawPath(path, paint);
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
}
