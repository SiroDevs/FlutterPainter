// Dart imports:
import 'dart:ui';

// Project imports:
import '../../models/shape.dart';
import '../../models/shape_gradient.dart';
import '../../models/shape_kind.dart';
import '../gradient_geometry.dart';
import 'code_transform.dart';
import 'code_values.dart';
import 'path_outline.dart';

// Gathers the shapes that the drawing calls of some code paint. A fill and a
// stroke of the same geometry, one after the other, become one shape.
class ShapeCollector {
  final List<Shape> shapes = [];
  String currentName = '';

  void addRect(Rect rect, double radius, CodePaint paint, CodeTransform t) {
    final box = t.applyRect(rect);
    _add(_closed(ShapeKind.rect, [box.topLeft, box.bottomRight], paint, t,
        radius: radius * t.scale));
  }

  void addEllipse(Rect rect, CodePaint paint, CodeTransform t) {
    final box = t.applyRect(rect);
    _add(_closed(ShapeKind.ellipse, [box.topLeft, box.bottomRight], paint, t));
  }

  void addLine(Offset from, Offset to, CodePaint paint, CodeTransform t) {
    _add(_stroked(ShapeKind.line, [t.apply(from), t.apply(to)], paint, t));
  }

  void addPath(List<PathSegment> segments, CodePaint paint, CodeTransform t) {
    for (final outline in outlinesOf(segments)) {
      List<Offset> moved(List<Offset> points) => [for (final p in points) t.apply(p)];
      switch (outline.kind) {
        case OutlineKind.rect:
          addRect(Rect.fromPoints(outline.points[0], outline.points[1]), 0, paint, t);
        case OutlineKind.ellipse:
          addEllipse(Rect.fromPoints(outline.points[0], outline.points[1]), paint, t);
        case OutlineKind.polygon:
          _add(_closed(ShapeKind.polygon, moved(outline.points), paint, t));
        case OutlineKind.freehand when !paint.isFill:
          _add(_stroked(ShapeKind.freehand, moved(outline.points), paint, t));
        case OutlineKind.freehand || OutlineKind.line when paint.isFill:
          _add(_closed(ShapeKind.polygon, moved(outline.flattened), paint, t));
        default:
          _add(_stroked(ShapeKind.line, moved(outline.flattened), paint, t));
      }
    }
  }

  Shape _stroked(ShapeKind kind, List<Offset> points, CodePaint paint, CodeTransform t) =>
      Shape(
        kind: kind,
        points: points,
        name: currentName,
        stroke: paint.color,
        strokeWidth: paint.strokeWidth * t.scale,
      );

  Shape _closed(
    ShapeKind kind,
    List<Offset> points,
    CodePaint paint,
    CodeTransform t, {
    double radius = 0,
  }) {
    final shape = Shape(
      kind: kind,
      points: points,
      name: currentName,
      radius: radius,
    );
    if (!paint.isFill) {
      return Shape(
        kind: kind,
        points: points,
        name: currentName,
        stroke: paint.color,
        strokeWidth: paint.strokeWidth * t.scale,
        radius: radius,
      );
    }
    final gradient = _gradientFor(paint.gradient, shape.bounds, t);
    return Shape(
      kind: kind,
      points: points,
      name: currentName,
      fill: gradient?.firstColor ?? paint.color,
      gradient: gradient,
      radius: radius,
    );
  }

  ShapeGradient? _gradientFor(CodeGradient? source, Rect bounds, CodeTransform t) {
    if (source == null) return null;
    final anchor = gradientFraction(t.apply(source.anchor), bounds);
    final target = source.target;
    return ShapeGradient(
      kind: source.kind,
      colors: source.colors,
      stops: source.stops,
      begin: anchor,
      end: target == null ? const Offset(1, 0.5) : gradientFraction(t.apply(target), bounds),
      radius: source.kind == GradientKind.radial
          ? gradientRadiusFraction(source.radius * t.scale, bounds)
          : 0.5,
    );
  }

  void _add(Shape shape) {
    final last = shapes.isEmpty ? null : shapes.last;
    if (last != null && _canMerge(last, shape)) {
      shapes[shapes.length - 1] = Shape(
        kind: last.kind,
        points: last.points,
        name: last.name,
        fill: shape.fill ?? last.fill,
        gradient: shape.gradient ?? last.gradient,
        stroke: shape.stroke ?? last.stroke,
        strokeWidth: shape.stroke != null ? shape.strokeWidth : last.strokeWidth,
        radius: last.radius,
      );
    } else {
      shapes.add(shape);
    }
  }

  bool _canMerge(Shape last, Shape next) {
    if (last.kind != next.kind || last.radius != next.radius) return false;
    if (last.points.length != next.points.length) return false;
    for (var i = 0; i < last.points.length; i++) {
      if (last.points[i] != next.points[i]) return false;
    }
    final fillThenStroke = last.stroke == null && next.fill == null;
    final strokeThenFill = last.fill == null && next.stroke == null;
    return last.isClosed && (fillThenStroke || strokeThenFill);
  }
}
