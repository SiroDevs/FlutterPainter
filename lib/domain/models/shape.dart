// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../core/utils/copy_with_util.dart';
import 'shape_kind.dart';

/// One drawable thing. Colours are 0xAARRGGBB ints (null = not painted).
///
/// - rect / ellipse: `points` holds two opposite corners.
/// - line / polygon: `points` are the vertices (polygon is closed).
/// - freehand: `points` are sampled along the stroke and drawn smoothed.
///
/// Immutable: edits make a new [Shape] with `copyWith`.
class Shape extends Equatable {
  const Shape({
    required this.kind,
    required this.points,
    this.name = '',
    this.fill,
    this.stroke,
    this.strokeWidth = 1.0,
    this.radius = 0.0,
  });

  final ShapeKind kind;
  final List<Offset> points;
  final String name;
  final int? fill;
  final int? stroke;
  final double strokeWidth;
  final double radius;

  Shape copyWith({
    ShapeKind? kind,
    List<Offset>? points,
    String? name,
    Object? fill = unset,
    Object? stroke = unset,
    double? strokeWidth,
    double? radius,
  }) =>
      Shape(
        kind: kind ?? this.kind,
        points: points ?? this.points,
        name: name ?? this.name,
        fill: keep<int>(fill, this.fill),
        stroke: keep<int>(stroke, this.stroke),
        strokeWidth: strokeWidth ?? this.strokeWidth,
        radius: radius ?? this.radius,
      );

  @override
  List<Object?> get props =>
      [kind, points, name, fill, stroke, strokeWidth, radius];

  bool get isClosed => kind != ShapeKind.line && kind != ShapeKind.freehand;
  bool get usesVertices => kind == ShapeKind.line || kind == ShapeKind.polygon;

  Rect get bounds {
    if (kind == ShapeKind.rect || kind == ShapeKind.ellipse) {
      return Rect.fromPoints(points[0], points[1]);
    }
    var r = Rect.fromPoints(points.first, points.first);
    for (final p in points) {
      r = Rect.fromLTRB(math.min(r.left, p.dx), math.min(r.top, p.dy),
          math.max(r.right, p.dx), math.max(r.bottom, p.dy));
    }
    return r;
  }

  /// Corner radius after clamping to what the rectangle can actually show.
  double get effectiveRadius {
    final b = bounds;
    return math.min(radius, math.min(b.width, b.height) / 2);
  }
}
