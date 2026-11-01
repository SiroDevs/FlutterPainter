// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../models/shape_gradient.dart';

// Turns a gradient's fractions into points on a shape's [bounds].
Offset gradientPoint(Offset fraction, Rect bounds) => Offset(
      bounds.left + fraction.dx * bounds.width,
      bounds.top + fraction.dy * bounds.height,
    );

// Turns a point on a shape's [bounds] back into fractions.
Offset gradientFraction(Offset point, Rect bounds) => Offset(
      bounds.width == 0 ? 0.5 : (point.dx - bounds.left) / bounds.width,
      bounds.height == 0 ? 0.5 : (point.dy - bounds.top) / bounds.height,
    );

// The radius of a radial gradient on [bounds].
double gradientRadius(ShapeGradient gradient, Rect bounds) =>
    gradient.radius * math.max(bounds.width, bounds.height);

// The radius fraction for an absolute [radius] on [bounds].
double gradientRadiusFraction(double radius, Rect bounds) {
  final longest = math.max(bounds.width, bounds.height);
  return longest == 0 ? 0.5 : radius / longest;
}
