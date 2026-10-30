// Dart imports:
import 'dart:ui';

// Project imports:
import '../models/shape_gradient.dart';
import 'code_format.dart';
import 'gradient_geometry.dart';

// The statements that make `_paint` fill with [gradient] over [bounds].
// [colorRef] writes one colour the way the rest of the export does.
List<String> gradientFillLines(
  ShapeGradient gradient,
  Rect bounds,
  String Function(int argb) colorRef,
) {
  String offset(Offset p) => 'const Offset(${fmt(p.dx)}, ${fmt(p.dy)})';
  final begin = offset(gradientPoint(gradient.begin, bounds));
  final geometry = switch (gradient.kind) {
    GradientKind.linear => [
        begin,
        offset(gradientPoint(gradient.end, bounds)),
      ],
    GradientKind.radial => [
        begin,
        fmt(gradientRadius(gradient, bounds)),
      ],
    GradientKind.sweep => [begin],
  };
  final colors = [for (final argb in gradient.colors) colorRef(argb)];
  final stops = [for (final stop in gradient.stops) fmtN(stop, 3)];
  return [
    '_paint',
    '  ..style = PaintingStyle.fill',
    '  ..shader = Gradient.${gradient.kind.name}(',
    for (final argument in geometry) '    $argument,',
    '    const [${colors.join(', ')}],',
    '    const [${stops.join(', ')}],',
    '  );',
  ];
}
