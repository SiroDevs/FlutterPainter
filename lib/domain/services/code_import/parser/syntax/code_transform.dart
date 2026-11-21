// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// A translation and scale set up with canvas.translate and canvas.scale.
class CodeTransform {
  const CodeTransform(this.shiftX, this.shiftY, this.scaleX, this.scaleY);

  static const identity = CodeTransform(0, 0, 1, 1);

  final double shiftX;
  final double shiftY;
  final double scaleX;
  final double scaleY;

  // The average scale, for widths and radii.
  double get scale => math.sqrt((scaleX * scaleY).abs());

  Offset apply(Offset point) =>
      Offset(point.dx * scaleX + shiftX, point.dy * scaleY + shiftY);

  Rect applyRect(Rect rect) =>
      Rect.fromPoints(apply(rect.topLeft), apply(rect.bottomRight));

  CodeTransform translated(double dx, double dy) =>
      CodeTransform(shiftX + dx * scaleX, shiftY + dy * scaleY, scaleX, scaleY);

  CodeTransform scaled(double sx, double sy) =>
      CodeTransform(shiftX, shiftY, scaleX * sx, scaleY * sy);
}
