// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'style_settings.freezed.dart';

/// The colours and stroke used for the next shape drawn. With a shape selected
/// these mirror that shape, so edits apply to it.
@freezed
abstract class StyleSettings with _$StyleSettings {
  const factory StyleSettings({
    @Default(0xFFED1C24) int fillColor,
    @Default(true) bool fillOn,
    @Default(0xFF000000) int strokeColor,
    @Default(true) bool strokeOn,
    @Default(1.0) double strokeWidth,
    @Default(0.0) double radius,

    /// Which swatch a palette click paints: true = fill, false = stroke.
    @Default(true) bool editFill,
  }) = _StyleSettings;
}
