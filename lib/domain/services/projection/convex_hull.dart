// Dart imports:
import 'dart:ui';

/// The smallest convex outline around [points].
List<Offset> convexHull(List<Offset> points) {
  final sorted = [...points]..sort(_byPosition);
  if (sorted.length < 3) return sorted;
  final lower = _chain(sorted)..removeLast();
  final upper = _chain(sorted.reversed)..removeLast();
  return [...lower, ...upper];
}

int _byPosition(Offset first, Offset second) {
  final byColumn = first.dx.compareTo(second.dx);
  return byColumn != 0 ? byColumn : first.dy.compareTo(second.dy);
}

List<Offset> _chain(Iterable<Offset> points) {
  final chain = <Offset>[];
  for (final point in points) {
    while (chain.length >= 2 &&
        _cross(chain[chain.length - 2], chain.last, point) <= 0) {
      chain.removeLast();
    }
    chain.add(point);
  }
  return chain;
}

double _cross(Offset origin, Offset first, Offset second) {
  final toFirst = first - origin;
  final toSecond = second - origin;
  return toFirst.dx * toSecond.dy - toFirst.dy * toSecond.dx;
}
