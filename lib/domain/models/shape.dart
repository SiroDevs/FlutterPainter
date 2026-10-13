// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'shape_kind.dart';

part 'shape.freezed.dart';

/// One drawable thing. Colours are 0xAARRGGBB ints (null = not painted).
///
/// - rect / ellipse: `points` holds two opposite corners.
/// - line / polygon: `points` are the vertices (polygon is closed).
/// - freehand: `points` are sampled along the stroke and drawn smoothed.
///
/// Immutable: edits make a new [Shape] with `copyWith`.
@freezed
abstract class Shape with _$Shape {
  const Shape._();

  const factory Shape({
    required ShapeKind kind,
    required List<Offset> points,
    @Default('') String name,
    int? fill,
    int? stroke,
    @Default(1.0) double strokeWidth,
    @Default(0.0) double radius,
  }) = _Shape;

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
