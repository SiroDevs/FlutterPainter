// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_settings.freezed.dart';

/// How the canvas is shown: zoom, pan, grid, snapping and background colour.
@freezed
abstract class ViewSettings with _$ViewSettings {
  const factory ViewSettings({
    @Default(6.0) double zoom,
    @Default(Offset(40, 40)) Offset pan,
    @Default(Size.zero) Size viewport,
    @Default(true) bool needsFit,
    @Default(true) bool snap,
    @Default(true) bool grid,

    /// Index into the list of workspace background colours.
    @Default(0) int background,
  }) = _ViewSettings;
}
