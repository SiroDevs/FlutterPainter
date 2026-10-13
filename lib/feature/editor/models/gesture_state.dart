// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';

/// What the pointer is currently doing.
enum GestureMode { none, draw, move, scale, vertex, referenceDrag }

/// The state of a pointer gesture in progress. It lives in the bloc state (not
/// in the widget) so the whole interaction is deterministic and testable.
class GestureState extends Equatable {
  const GestureState({
    this.mode = GestureMode.none,
    this.origin = Offset.zero,
    this.last = Offset.zero,
    this.handle = -1,
    this.startPoints = const <Offset>[],
    this.startBounds = Rect.zero,
    this.lastClickMs = 0,
  });

  final GestureMode mode;

  /// Where the gesture began (design units).
  final Offset origin;

  /// The previous pointer position, for relative drags.
  final Offset last;

  /// The grabbed handle: a corner (0-3) or a vertex index.
  final int handle;

  /// The grabbed shape's points and box when the drag began.
  final List<Offset> startPoints;
  final Rect startBounds;

  /// Time of the previous click, to detect double-clicks.
  final int lastClickMs;

  GestureState copyWith({
    GestureMode? mode,
    Offset? origin,
    Offset? last,
    int? handle,
    List<Offset>? startPoints,
    Rect? startBounds,
    int? lastClickMs,
  }) =>
      GestureState(
        mode: mode ?? this.mode,
        origin: origin ?? this.origin,
        last: last ?? this.last,
        handle: handle ?? this.handle,
        startPoints: startPoints ?? this.startPoints,
        startBounds: startBounds ?? this.startBounds,
        lastClickMs: lastClickMs ?? this.lastClickMs,
      );

  @override
  List<Object?> get props =>
      [mode, origin, last, handle, startPoints, startBounds, lastClickMs];
}
