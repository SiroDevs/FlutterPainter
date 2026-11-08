// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import 'shape_gradient.dart';
import 'shape_kind.dart';

/// One drawable thing. Colours are 0xAARRGGBB ints (null = not painted).
///
/// - rect / ellipse: `points` holds two opposite corners.
/// - line / polygon: `points` are the vertices (polygon is closed).
/// - freehand: `points` are sampled along the stroke and drawn smoothed.
/// - gradient: paints the fill instead of the flat colour; `fill` then holds
///   the first stop so a shape with a gradient always has a fill.
///
/// Immutable: edits make a new [Shape] with `copyWith`.
class Shape extends Equatable {
  const Shape({
    required this.kind,
    required this.points,
    this.name = '',
    this.fill,
    this.gradient,
    this.stroke,
    this.strokeWidth = 1.0,
    this.radius = 0.0,
    this.groupId,
    this.groupName,
    this.rotation = 0,
    this.visible = true,
  });

  final ShapeKind kind;
  final List<Offset> points;
  final String name;
  final int? fill;
  final ShapeGradient? gradient;
  final int? stroke;
  final double strokeWidth;
  final double radius;

  /// Shapes with the same non-null id move and select together.
  final String? groupId;
  final String? groupName;
  final double rotation;
  final bool visible;

  Shape copyWith({
    ShapeKind? kind,
    List<Offset>? points,
    String? name,
    Object? fill = unset,
    Object? gradient = unset,
    Object? stroke = unset,
    double? strokeWidth,
    double? radius,
    Object? groupId = unset,
    Object? groupName = unset,
    double? rotation,
    bool? visible,
  }) => Shape(
    kind: kind ?? this.kind,
    points: points ?? this.points,
    name: name ?? this.name,
    fill: keep<int>(fill, this.fill),
    gradient: keep<ShapeGradient>(gradient, this.gradient),
    stroke: keep<int>(stroke, this.stroke),
    strokeWidth: strokeWidth ?? this.strokeWidth,
    radius: radius ?? this.radius,
    groupId: keep<String>(groupId, this.groupId),
    groupName: keep<String>(groupName, this.groupName),
    rotation: rotation ?? this.rotation,
    visible: visible ?? this.visible,
  );

  @override
  List<Object?> get props => [
    kind,
    points,
    name,
    fill,
    gradient,
    stroke,
    strokeWidth,
    radius,
    groupId,
    groupName,
    rotation,
    visible,
  ];

  bool get isClosed => kind != ShapeKind.line && kind != ShapeKind.freehand;
  bool get usesVertices => kind == ShapeKind.line || kind == ShapeKind.polygon;

  Rect get unrotatedBounds {
    if (kind == ShapeKind.rect || kind == ShapeKind.ellipse) {
      return Rect.fromPoints(points[0], points[1]);
    }
    var r = Rect.fromPoints(points.first, points.first);
    for (final p in points) {
      r = Rect.fromLTRB(
        math.min(r.left, p.dx),
        math.min(r.top, p.dy),
        math.max(r.right, p.dx),
        math.max(r.bottom, p.dy),
      );
    }
    return r;
  }

  Rect get bounds {
    final local = unrotatedBounds;
    if (rotation == 0) return local;
    final center = local.center;
    if (kind == ShapeKind.ellipse) {
      final radiusX = local.width / 2;
      final radiusY = local.height / 2;
      final cosAngle = math.cos(rotation);
      final sinAngle = math.sin(rotation);
      final extentX = math.sqrt(
        math.pow(radiusX * cosAngle, 2) + math.pow(radiusY * sinAngle, 2),
      );
      final extentY = math.sqrt(
        math.pow(radiusX * sinAngle, 2) + math.pow(radiusY * cosAngle, 2),
      );
      return Rect.fromCenter(
        center: center,
        width: extentX * 2,
        height: extentY * 2,
      );
    }
    final corners = [
      local.topLeft,
      local.topRight,
      local.bottomRight,
      local.bottomLeft,
    ].map((point) => rotatePoint(point, rotation, center));
    var result = Rect.fromPoints(corners.first, corners.first);
    for (final point in corners.skip(1)) {
      result = Rect.fromLTRB(
        math.min(result.left, point.dx),
        math.min(result.top, point.dy),
        math.max(result.right, point.dx),
        math.max(result.bottom, point.dy),
      );
    }
    return result;
  }

  static Offset rotatePoint(Offset point, double angle, Offset center) {
    final relative = point - center;
    final cosAngle = math.cos(angle);
    final sinAngle = math.sin(angle);
    return center +
        Offset(
          relative.dx * cosAngle - relative.dy * sinAngle,
          relative.dx * sinAngle + relative.dy * cosAngle,
        );
  }

  /// Corner radius after clamping to what the rectangle can actually show.
  double get effectiveRadius {
    final b = unrotatedBounds;
    return math.min(radius, math.min(b.width, b.height) / 2);
  }
}
