import '../../models/shapes/shape_kind.dart';
import 'quick_code_points.dart';

enum QuickCodeStatus { empty, invalid, tooFew, ready }

abstract class QuickCodeValidation {
  QuickCodeValidation._();

  static QuickCodeStatus status(
    List<QuickCodeShapeData>? shapes,
    ShapeKind? kind,
  ) {
    if (shapes == null) return QuickCodeStatus.invalid;
    if (shapes.isEmpty) return QuickCodeStatus.empty;
    if (kind != null && shapes.length != 1) return QuickCodeStatus.invalid;
    final insufficient = shapes.any(
      (shape) => shape.points.length < _minimum(kind),
    );
    if (insufficient) return QuickCodeStatus.tooFew;
    final invalid = shapes.any((shape) => !_validCount(shape, kind));
    return invalid ? QuickCodeStatus.invalid : QuickCodeStatus.ready;
  }

  static int _minimum(ShapeKind? kind) => switch (kind) {
    ShapeKind.rect ||
    ShapeKind.ellipse ||
    ShapeKind.line ||
    ShapeKind.freehand => 2,
    ShapeKind.polygon || null => 3,
  };

  static bool _validCount(QuickCodeShapeData shape, ShapeKind? kind) =>
      switch (kind) {
        ShapeKind.rect || ShapeKind.ellipse => shape.points.length == 2,
        ShapeKind.line || ShapeKind.freehand => shape.points.length >= 2,
        ShapeKind.polygon || null => shape.points.length >= 3,
      };
}
