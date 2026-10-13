// Package imports:
import 'package:equatable/equatable.dart';

/// The colours and stroke used for the next shape drawn. With a shape selected
/// these mirror that shape, so edits apply to it.
class StyleSettings extends Equatable {
  const StyleSettings({
    this.fillColor = 0xFFED1C24,
    this.fillOn = true,
    this.strokeColor = 0xFF000000,
    this.strokeOn = true,
    this.strokeWidth = 1.0,
    this.radius = 0.0,
    this.editFill = true,
  });

  final int fillColor;
  final bool fillOn;
  final int strokeColor;
  final bool strokeOn;
  final double strokeWidth;
  final double radius;

  /// Which swatch a palette click paints: true = fill, false = stroke.
  final bool editFill;

  StyleSettings copyWith({
    int? fillColor,
    bool? fillOn,
    int? strokeColor,
    bool? strokeOn,
    double? strokeWidth,
    double? radius,
    bool? editFill,
  }) =>
      StyleSettings(
        fillColor: fillColor ?? this.fillColor,
        fillOn: fillOn ?? this.fillOn,
        strokeColor: strokeColor ?? this.strokeColor,
        strokeOn: strokeOn ?? this.strokeOn,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        radius: radius ?? this.radius,
        editFill: editFill ?? this.editFill,
      );

  @override
  List<Object?> get props =>
      [fillColor, fillOn, strokeColor, strokeOn, strokeWidth, radius, editFill];
}
