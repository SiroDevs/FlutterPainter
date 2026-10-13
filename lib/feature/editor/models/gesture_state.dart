// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gesture_state.freezed.dart';

/// What the pointer is currently doing.
enum GestureMode { none, draw, move, scale, vertex, referenceDrag }

/// The state of a pointer gesture in progress. It lives in the bloc state (not
/// in the widget) so the whole interaction is deterministic and testable.
@freezed
abstract class GestureState with _$GestureState {
  const factory GestureState({
    @Default(GestureMode.none) GestureMode mode,

    /// Where the gesture began (design units).
    @Default(Offset.zero) Offset origin,

    /// The previous pointer position, for relative drags.
    @Default(Offset.zero) Offset last,

    /// The grabbed handle: a corner (0-3) or a vertex index.
    @Default(-1) int handle,

    /// The grabbed shape's points and box when the drag began.
    @Default(<Offset>[]) List<Offset> startPoints,
    @Default(Rect.zero) Rect startBounds,

    /// Time of the previous click, to detect double-clicks.
    @Default(0) int lastClickMs,
  }) = _GestureState;
}
