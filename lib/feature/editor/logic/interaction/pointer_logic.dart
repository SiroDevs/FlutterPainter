// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/editor/tool.dart';
import '../../bloc/editor_bloc.dart';
import '../../models/gesture_state.dart';
import '../canvas/image_logic.dart';
import '../drawing/draw_logic.dart';
import 'select_logic.dart';

/// Routes raw pointer events to the active tool, or to the gesture in progress.
abstract class PointerLogic {
  PointerLogic._();

  static EditorState pressed(EditorState s, PointerPressed e) {
    final next = s.copyWith(cursor: e.point);
    switch (s.tool) {
      case Tool.select:
        return SelectLogic.pressed(
          next,
          e.point,
          alt: e.alt,
          shift: e.shift,
          control: e.control,
          timeMs: e.timeMs,
        );
      case Tool.reference:
        return ImageLogic.pressed(next, e.point);
      case Tool.rect:
      case Tool.ellipse:
      case Tool.line:
      case Tool.polygon:
      case Tool.freehand:
        return DrawLogic.pressed(next, e.point, e.timeMs);
    }
  }

  static EditorState moved(EditorState s, PointerMoved e) {
    final next = s.copyWith(cursor: e.point);
    switch (s.gesture.mode) {
      case GestureMode.draw:
        return DrawLogic.moved(next, e.point, e.shift);
      case GestureMode.move:
      case GestureMode.scale:
      case GestureMode.rotate:
      case GestureMode.vertex:
      case GestureMode.marquee:
        return SelectLogic.moved(next, e.point, shift: e.shift);
      case GestureMode.imageMove:
      case GestureMode.imageScale:
        return ImageLogic.dragged(next, e.point, e.shift);
      case GestureMode.none:
        return next;
    }
  }

  static EditorState released(EditorState s) {
    switch (s.gesture.mode) {
      case GestureMode.draw:
        return DrawLogic.released(s);
      case GestureMode.move:
      case GestureMode.scale:
      case GestureMode.rotate:
      case GestureMode.vertex:
      case GestureMode.marquee:
        return SelectLogic.released(s);
      case GestureMode.imageMove:
      case GestureMode.imageScale:
        return ImageLogic.released(s);
      case GestureMode.none:
        return s;
    }
  }

  static EditorState hovered(EditorState s, Offset p) =>
      DrawLogic.hovered(s.copyWith(cursor: p), p);
}
