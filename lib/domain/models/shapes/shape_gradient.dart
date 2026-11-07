// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';

/// How a gradient spreads its colours.
enum GradientKind { linear, radial, sweep }

/// A gradient fill positioned relative to the shape it fills. [begin] and
/// [end] are fractions of the shape's bounds (0,0 top-left, 1,1 bottom-right),
/// so the gradient follows the shape when it moves or is resized.
///
/// - linear: runs from [begin] to [end].
/// - radial: centred on [begin], reaching [radius] times the longer side.
/// - sweep: centred on [begin].
class ShapeGradient extends Equatable {
  const ShapeGradient({
    required this.kind,
    required this.colors,
    required this.stops,
    this.begin = const Offset(0, 0.5),
    this.end = const Offset(1, 0.5),
    this.radius = 0.5,
  });

  factory ShapeGradient.initial(GradientKind kind, int from, int to) =>
      ShapeGradient(
        kind: kind,
        colors: [from, to],
        stops: const [0, 1],
        begin: kind == GradientKind.linear
            ? const Offset(0, 0.5)
            : const Offset(0.5, 0.5),
      );

  final GradientKind kind;
  final List<int> colors;
  final List<double> stops;
  final Offset begin;
  final Offset end;
  final double radius;

  int get firstColor => colors.first;

  /// The direction of a linear gradient, in degrees (0 = left to right).
  double get angleDegrees {
    final delta = end - begin;
    return math.atan2(delta.dy, delta.dx) * 180 / math.pi;
  }

  /// A linear gradient across the whole shape at [degrees].
  ShapeGradient withAngle(double degrees) {
    final radians = degrees * math.pi / 180;
    final direction = Offset(math.cos(radians), math.sin(radians));
    final half = 0.5 * (direction.dx.abs() + direction.dy.abs());
    const center = Offset(0.5, 0.5);
    return copyWith(
      begin: center - direction * half,
      end: center + direction * half,
    );
  }

  /// The same colours spread in another [newKind], with default geometry.
  ShapeGradient withKind(GradientKind newKind) {
    final fresh = ShapeGradient.initial(newKind, colors.first, colors.last);
    return fresh.copyWith(colors: colors, stops: stops);
  }

  ShapeGradient copyWith({
    GradientKind? kind,
    List<int>? colors,
    List<double>? stops,
    Offset? begin,
    Offset? end,
    double? radius,
  }) =>
      ShapeGradient(
        kind: kind ?? this.kind,
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        begin: begin ?? this.begin,
        end: end ?? this.end,
        radius: radius ?? this.radius,
      );

  @override
  List<Object?> get props => [kind, colors, stops, begin, end, radius];
}
