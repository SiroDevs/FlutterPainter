// Dart imports:
import 'dart:ui';

// Project imports:
import '../../models/shape_gradient.dart';

// A statement or expression the importer cannot read.
class CodeUnsupported implements Exception {
  const CodeUnsupported(this.message);

  final String message;

  @override
  String toString() => message;
}

// A call to something the importer does not know, which may still be a method
// on a value.
class CodeUnknownCall extends CodeUnsupported {
  const CodeUnknownCall(super.message);
}

// A colour read from code.
class CodeColor {
  const CodeColor(this.argb);

  final int argb;
}

// A rounded rectangle with one corner radius.
class CodeRRect {
  const CodeRRect(this.rect, this.radius);

  final Rect rect;
  final double radius;
}

// A gradient read from code, still in absolute coordinates. [anchor] is the
// start of a linear gradient or the centre of a radial or sweep one.
class CodeGradient {
  const CodeGradient({
    required this.kind,
    required this.anchor,
    required this.colors,
    required this.stops,
    this.target,
    this.radius = 0,
  });

  final GradientKind kind;
  final Offset anchor;
  final Offset? target;
  final double radius;
  final List<int> colors;
  final List<double> stops;
}

// Stands for the canvas parameter of a painting method.
class CodeCanvas {
  const CodeCanvas();
}

// The parts of a Paint that decide how a shape looks.
class CodePaint {
  CodePaint({
    this.isFill = true,
    this.strokeWidth = 0,
    this.color = 0xFF000000,
    this.gradient,
  });

  bool isFill;
  double strokeWidth;
  int color;
  CodeGradient? gradient;

  CodePaint copy() => CodePaint(
        isFill: isFill,
        strokeWidth: strokeWidth,
        color: color,
        gradient: gradient,
      );
}

enum PathOp { move, line, quad, cubic, close, rect, oval }

// One step of a path being built.
class PathSegment {
  const PathSegment(this.op, [this.points = const <Offset>[]]);

  final PathOp op;
  final List<Offset> points;
}

// A path being built by moveTo, lineTo and friends.
class CodePath {
  final List<PathSegment> segments = [];
}
