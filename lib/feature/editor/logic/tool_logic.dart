// Project imports:
import '../../../domain/models/tool.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';

abstract class ToolLogic {
  ToolLogic._();

  /// Switching tools drops the selection and any shape half-drawn.
  static EditorState select(EditorState s, Tool tool) => s.copyWith(
        tool: tool,
        selected: null,
        draft: null,
        hover: null,
        gesture: const GestureState(),
      );
}
