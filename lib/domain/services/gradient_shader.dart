// Dart imports:
import 'dart:ui';

// Project imports:
import '../models/shape_gradient.dart';
import 'gradient_geometry.dart';

// Builds the shader that paints [gradient] over a shape with [bounds].
Shader gradientShader(ShapeGradient gradient, Rect bounds) {
  final colors = [for (final argb in gradient.colors) Color(argb)];
  final center = gradientPoint(gradient.begin, bounds);
  return switch (gradient.kind) {
    GradientKind.linear => Gradient.linear(
        center,
        gradientPoint(gradient.end, bounds),
        colors,
        gradient.stops,
      ),
    GradientKind.radial => Gradient.radial(
        center,
        gradientRadius(gradient, bounds),
        colors,
        gradient.stops,
      ),
    GradientKind.sweep => Gradient.sweep(center, colors, gradient.stops),
  };
}
