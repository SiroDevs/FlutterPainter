// Dart imports:
import 'dart:ui';

// Project imports:
import 'code_values.dart';

enum OutlineKind { rect, ellipse, polygon, line, freehand }

// One closed or open outline of a path, ready to become a shape. [points] are
// what the shape stores; [flattened] follows the curves, for a filled paint.
class PathOutline {
  const PathOutline(this.kind, this.points, this.flattened);

  final OutlineKind kind;
  final List<Offset> points;
  final List<Offset> flattened;
}

Offset _along(Offset a, Offset control, Offset b, double t) {
  final u = 1 - t;
  return a * (u * u) + control * (2 * u * t) + b * (t * t);
}

// Splits [segments] into outlines. A path of one moveTo, quadratic curves
// through midpoints and a final lineTo is what a freehand stroke exports as,
// so it comes back as a freehand shape.
List<PathOutline> outlinesOf(List<PathSegment> segments) {
  final outlines = <PathOutline>[];
  var points = <Offset>[];
  var operations = <PathOp>[];
  var controls = <Offset>[];
  var ends = <Offset>[];

  void flush(bool closed) {
    if (points.length >= 2) {
      outlines.add(_outline(points, operations, controls, ends, closed));
    }
    points = [];
    operations = [];
    controls = [];
    ends = [];
  }

  for (final segment in segments) {
    final p = segment.points;
    if (segment.op == PathOp.close) {
      flush(true);
      continue;
    }
    if (segment.op == PathOp.rect || segment.op == PathOp.oval) {
      flush(false);
      final kind =
          segment.op == PathOp.rect ? OutlineKind.rect : OutlineKind.ellipse;
      outlines.add(PathOutline(kind, p, p));
      continue;
    }
    if (segment.op == PathOp.move) {
      flush(false);
      points = [p[0]];
      operations = [PathOp.move];
      continue;
    }
    if (points.isEmpty) {
      points = [Offset.zero];
      operations = [PathOp.move];
    }
    if (segment.op == PathOp.line) {
      points.add(p[0]);
    } else if (segment.op == PathOp.quad) {
      final start = points.last;
      for (var step = 1; step <= 8; step++) {
        points.add(_along(start, p[0], p[1], step / 8));
      }
      controls.add(p[0]);
      ends.add(p[1]);
    } else {
      final start = points.last;
      for (var step = 1; step <= 12; step++) {
        final t = step / 12;
        final u = 1 - t;
        points.add(start * (u * u * u) +
            p[0] * (3 * u * u * t) +
            p[1] * (3 * u * t * t) +
            p[2] * (t * t * t));
      }
    }
    operations.add(segment.op);
  }
  flush(false);
  return outlines;
}

PathOutline _outline(
  List<Offset> points,
  List<PathOp> operations,
  List<Offset> controls,
  List<Offset> ends,
  bool closed,
) {
  if (closed && points.length >= 3) {
    return PathOutline(OutlineKind.polygon, points, points);
  }
  if (!closed && _isFreehand(points, operations, controls, ends)) {
    return PathOutline(
      OutlineKind.freehand,
      [points.first, ...controls, points.last],
      points,
    );
  }
  return PathOutline(OutlineKind.line, points, points);
}

bool _isFreehand(
  List<Offset> points,
  List<PathOp> operations,
  List<Offset> controls,
  List<Offset> ends,
) {
  if (controls.isEmpty || operations.length != controls.length + 2) {
    return false;
  }
  if (operations.first != PathOp.move || operations.last != PathOp.line) {
    return false;
  }
  if (operations.sublist(1, operations.length - 1).any((o) => o != PathOp.quad)) {
    return false;
  }
  for (var i = 0; i < controls.length; i++) {
    final next = i + 1 < controls.length ? controls[i + 1] : points.last;
    final middle = (controls[i] + next) / 2;
    if ((ends[i] - middle).distance > 0.02) return false;
  }
  return true;
}
