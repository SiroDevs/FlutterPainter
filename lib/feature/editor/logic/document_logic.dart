// Project imports:
import '../../../domain/models/paint_layer.dart';
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

  /// Swaps in layers read from code. The selection goes, since the shapes it
  /// pointed at may no longer exist.
  static EditorState applyCode(EditorState s, List<PaintLayer> layers) {
    if (layers.isEmpty) return s;
    return s
        .withLayers(layers)
        .copyWith(
          layerIndex: s.layerIndex.clamp(0, layers.length - 1).toInt(),
          selected: null,
        )
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
