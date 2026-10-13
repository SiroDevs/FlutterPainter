// Project imports:
import '../../../domain/models/edit_history.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';

abstract class HistoryLogic {
  HistoryLogic._();

  static EditorState undo(EditorState s) {
    final h = s.history.undo();
    return h == null ? s : _jump(s, h);
  }

  static EditorState redo(EditorState s) {
    final h = s.history.redo();
    return h == null ? s : _jump(s, h);
  }

  static EditorState _jump(EditorState s, EditHistory history) {
    final d = history.current;
    return s.copyWith(
      history: history,
      drawing: d,
      layerIndex: s.layerIndex.clamp(0, d.layers.length - 1).toInt(),
      selected: null,
      draft: null,
      hover: null,
      gesture: const GestureState(),
      revision: s.revision + 1,
    );
  }
}
