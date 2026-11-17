// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/models/shapes/shape_kind.dart';
import 'package:flutter_painter/domain/services/geometry/shape_geometry.dart';

void main() {
  const rect = Shape(
    kind: ShapeKind.rect,
    points: [Offset(0, 0), Offset(20, 10)],
    fill: 0xFF000000,
  );

  group('Shape bounds', () {
    test('rect bounds come from its two corners in any order', () {
      const flipped = Shape(
        kind: ShapeKind.rect,
        points: [Offset(20, 10), Offset(0, 0)],
      );
      expect(flipped.unrotatedBounds, const Rect.fromLTRB(0, 0, 20, 10));
    });

    test('polygon bounds enclose every vertex', () {
      const poly = Shape(
        kind: ShapeKind.polygon,
        points: [Offset(-5, 3), Offset(10, -2), Offset(4, 12)],
      );
      expect(poly.unrotatedBounds, const Rect.fromLTRB(-5, -2, 10, 12));
    });

    test('rotating a rect by 90 degrees swaps its extents', () {
      final r = rect.copyWith(rotation: math.pi / 2);
      expect(r.bounds.width, closeTo(10, 1e-9));
      expect(r.bounds.height, closeTo(20, 1e-9));
      expect(r.bounds.center, rect.bounds.center);
    });

    test('unrotated bounds equal bounds', () {
      expect(rect.bounds, rect.unrotatedBounds);
    });

    test('effective radius is clamped to half the shorter side', () {
      expect(rect.copyWith(radius: 100).effectiveRadius, 5);
      expect(rect.copyWith(radius: 2).effectiveRadius, 2);
    });

    test('closedness by kind', () {
      expect(rect.isClosed, isTrue);
      expect(rect.copyWith(kind: ShapeKind.line).isClosed, isFalse);
      expect(rect.copyWith(kind: ShapeKind.freehand).isClosed, isFalse);
    });
  });

  group('hitTest', () {
    test('inside a filled rect hits, far outside misses', () {
      expect(rect.hitTest(const Offset(10, 5), 1), isTrue);
      expect(rect.hitTest(const Offset(50, 50), 1), isFalse);
    });

    test('tolerance extends the hit area', () {
      expect(rect.hitTest(const Offset(21, 5), 0.5), isFalse);
      expect(rect.hitTest(const Offset(21, 5), 2), isTrue);
    });

    test('line hits near the segment only', () {
      const line = Shape(
        kind: ShapeKind.line,
        points: [Offset(0, 0), Offset(10, 0)],
        stroke: 0xFF000000,
      );
      expect(line.hitTest(const Offset(5, 1), 2), isTrue);
      expect(line.hitTest(const Offset(5, 10), 2), isFalse);
    });

    test('rotation is taken into account', () {
      // A 20x10 rect rotated 90deg about (10,5) covers x 5..15, y -5..15.
      final r = rect.copyWith(rotation: math.pi / 2);
      expect(r.hitTest(const Offset(10, 13), 0.5), isTrue);
      expect(r.hitTest(const Offset(1, 5), 0.5), isFalse);
    });
  });

  group('buildPath', () {
    test('every kind produces a non-empty path', () {
      for (final kind in ShapeKind.values) {
        final s = Shape(
          kind: kind,
          points: kind == ShapeKind.rect || kind == ShapeKind.ellipse
              ? const [Offset(0, 0), Offset(10, 10)]
              : const [Offset(0, 0), Offset(5, 8), Offset(10, 0), Offset(12, 4)],
        );
        expect(s.buildPath().getBounds().isEmpty, isFalse, reason: '$kind');
      }
    });
  });
}
