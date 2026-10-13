// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';

/// How the canvas is shown: zoom, pan, grid, snapping and background colour.
class ViewSettings extends Equatable {
  const ViewSettings({
    this.zoom = 6.0,
    this.pan = const Offset(40, 40),
    this.viewport = Size.zero,
    this.needsFit = true,
    this.snap = true,
    this.grid = true,
    this.background = 0,
  });

  final double zoom;
  final Offset pan;
  final Size viewport;
  final bool needsFit;
  final bool snap;
  final bool grid;

  /// Index into the list of workspace background colours.
  final int background;

  ViewSettings copyWith({
    double? zoom,
    Offset? pan,
    Size? viewport,
    bool? needsFit,
    bool? snap,
    bool? grid,
    int? background,
  }) =>
      ViewSettings(
        zoom: zoom ?? this.zoom,
        pan: pan ?? this.pan,
        viewport: viewport ?? this.viewport,
        needsFit: needsFit ?? this.needsFit,
        snap: snap ?? this.snap,
        grid: grid ?? this.grid,
        background: background ?? this.background,
      );

  @override
  List<Object?> get props =>
      [zoom, pan, viewport, needsFit, snap, grid, background];
}
