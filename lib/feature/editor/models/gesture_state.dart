// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../domain/models/shape.dart';

/// What the pointer is currently doing.
enum GestureMode {
  none,
  draw,
  move,
  scale,
  rotate,
  vertex,
  marquee,
  imageMove,
  imageScale,
}

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
    this.startShapes = const <Shape>[],
    this.startIndices = const <int>[],
    this.selectionAtStart = const <int>[],
    this.additiveSelection = false,
  });

  final GestureMode mode;

  /// Where the gesture began (design units).
  final Offset origin;

  /// The previous pointer position, for relative drags.
  final Offset last;

  /// The grabbed handle: a shape corner (0-3), a vertex index, or one of a
  /// picture's eight handles.
  final int handle;

  /// The grabbed shape's points and box (or the picture's box) when the drag
  /// began.
  final List<Offset> startPoints;
  final Rect startBounds;

  /// Time of the previous click, to detect double-clicks.
  final int lastClickMs;

  /// Selected shapes and their indices when a move or rotation began.
  final List<Shape> startShapes;
  final List<int> startIndices;

  /// Existing selection retained when a shift-drag marquee is started.
  final List<int> selectionAtStart;
  final bool additiveSelection;

  GestureState copyWith({
    GestureMode? mode,
    Offset? origin,
    Offset? last,
    int? handle,
    List<Offset>? startPoints,
    Rect? startBounds,
    int? lastClickMs,
    List<Shape>? startShapes,
    List<int>? startIndices,
    List<int>? selectionAtStart,
    bool? additiveSelection,
  }) =>
      GestureState(
        mode: mode ?? this.mode,
        origin: origin ?? this.origin,
        last: last ?? this.last,
        handle: handle ?? this.handle,
        startPoints: startPoints ?? this.startPoints,
        startBounds: startBounds ?? this.startBounds,
        lastClickMs: lastClickMs ?? this.lastClickMs,
        startShapes: startShapes ?? this.startShapes,
        startIndices: startIndices ?? this.startIndices,
        selectionAtStart: selectionAtStart ?? this.selectionAtStart,
        additiveSelection: additiveSelection ?? this.additiveSelection,
      );

  @override
  List<Object?> get props =>
      [
        mode,
        origin,
        last,
        handle,
        startPoints,
        startBounds,
        lastClickMs,
        startShapes,
        startIndices,
        selectionAtStart,
        additiveSelection,
      ];
}
