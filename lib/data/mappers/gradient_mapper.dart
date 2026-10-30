// Dart imports:
import 'dart:ui';

// Project imports:
import '../../domain/models/shape_gradient.dart';

Map<String, dynamic> gradientToJson(ShapeGradient g) => {
      'kind': g.kind.name,
      'colors': g.colors,
      'stops': g.stops,
      'begin': [g.begin.dx, g.begin.dy],
      'end': [g.end.dx, g.end.dy],
      'radius': g.radius,
    };

ShapeGradient? gradientFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  Offset point(Object? raw, Offset fallback) => raw is List && raw.length == 2
      ? Offset((raw[0] as num).toDouble(), (raw[1] as num).toDouble())
      : fallback;
  final colors = [for (final c in json['colors'] as List) c as int];
  final stops = [for (final v in json['stops'] as List) (v as num).toDouble()];
  if (colors.length < 2 || colors.length != stops.length) return null;
  return ShapeGradient(
    kind: GradientKind.values.byName(json['kind'] as String),
    colors: colors,
    stops: stops,
    begin: point(json['begin'], const Offset(0, 0.5)),
    end: point(json['end'], const Offset(1, 0.5)),
    radius: ((json['radius'] as num?) ?? 0.5).toDouble(),
  );
}
