// Package imports:
// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../../../domain/models/shape_gradient.dart';

/// The colours and stroke used for the next shape drawn. With a shape selected
/// these mirror that shape, so edits apply to it.
class StyleSettings extends Equatable {
  const StyleSettings({
    this.fillColor = 0xFFED1C24,
    this.fillOn = true,
    this.fillGradient,
    this.strokeColor = 0xFF000000,
    this.strokeOn = true,
    this.strokeWidth = 1.0,
    this.radius = 0.0,
    this.editFill = true,
  });

  final int fillColor;
  final bool fillOn;

  /// A gradient used instead of [fillColor], or null for a flat fill.
  final ShapeGradient? fillGradient;
  final int strokeColor;
  final bool strokeOn;
  final double strokeWidth;
  final double radius;

  /// Which swatch a palette click paints: true = fill, false = stroke.
  final bool editFill;

  StyleSettings copyWith({
    int? fillColor,
    bool? fillOn,
    Object? fillGradient = unset,
    int? strokeColor,
    bool? strokeOn,
    double? strokeWidth,
    double? radius,
    bool? editFill,
  }) =>
      StyleSettings(
        fillColor: fillColor ?? this.fillColor,
        fillOn: fillOn ?? this.fillOn,
        fillGradient: keep<ShapeGradient>(fillGradient, this.fillGradient),
        strokeColor: strokeColor ?? this.strokeColor,
        strokeOn: strokeOn ?? this.strokeOn,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        radius: radius ?? this.radius,
        editFill: editFill ?? this.editFill,
      );

  @override
  List<Object?> get props =>
      [
        fillColor,
        fillOn,
        fillGradient,
        strokeColor,
        strokeOn,
        strokeWidth,
        radius,
        editFill,
      ];
}
