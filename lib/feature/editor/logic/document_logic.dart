// Project imports:
import '../bloc/editor_bloc.dart';
import 'editor_ops.dart';
import 'view_logic.dart';

/// Whole-document operations: name, canvas size, and saving.
abstract class DocumentLogic {
  DocumentLogic._();

  static EditorState rename(EditorState s, String name) =>
      s.withDrawing(s.drawing.copyWith(name: name)).commit();

  static EditorState resizeCanvas(EditorState s, double width, double height) {
    final d = s.drawing.copyWith(width: width, height: height);
    return s
        .copyWith(drawing: d, view: ViewLogic.fitted(s.view, d, force: true))
        .commit();
  }

  /// The project was written to [path]: remember it and mark everything clean.
  static EditorState saved(EditorState s, String path) {
    final c = s.commit();
    return c.copyWith(
      filePath: path,
      overwriteConfirmed: true,
      history: c.history.markSaved(),
    );
  }
}
