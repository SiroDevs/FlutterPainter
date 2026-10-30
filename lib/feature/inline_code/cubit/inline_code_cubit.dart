// Dart imports:
import 'dart:async';
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../../../domain/models/app_settings.dart';
import '../../../domain/models/drawing.dart';
import '../../../domain/models/export_file.dart';
import '../../../domain/models/export_options.dart';
import '../../../domain/models/paint_layer.dart';
import '../../../domain/models/shape.dart';
import '../../../domain/services/code_import/code_importer.dart';
import '../../../domain/services/dart_exporter.dart';
import '../../editor/bloc/editor_bloc.dart';

part 'inline_code_state.dart';

// The inline code view of one project. The files are generated from the
// drawing; typing in one reads it back into shapes and updates the canvas as
// one undoable step. Changes made on the canvas regenerate the files.
class InlineCodeCubit extends Cubit<InlineCodeState> {
  InlineCodeCubit(this._editor, this._options)
      : _knownDrawing = _editor.state.drawing,
        super(const InlineCodeState(files: [], removablePaths: {})) {
    _regenerate(_knownDrawing);
    _subscription = _editor.stream.listen(_onEditorChanged);
  }

  static const _typingPause = Duration(milliseconds: 350);

  final EditorBloc _editor;
  final ExportOptions _options;
  late final StreamSubscription<EditorState> _subscription;
  final Set<String> _editedPaths = {};
  Map<String, int> _layerOfPath = {};
  Drawing _knownDrawing;
  Timer? _typingTimer;

  // Creates the cubit for [editor] with the user's colour settings and the
  // layered file layout, which is the one that maps files to layers.
  static InlineCodeCubit create(EditorBloc editor, AppSettings settings) =>
      InlineCodeCubit(
        editor,
        ExportOptions(
          style: CodeStyle.refactored,
          colorFormat: settings.colorFormat,
          colorConstants: settings.colorConstants,
        ),
      );

  void select(String path) {
    if (state.fileAt(path) != null) emit(state.copyWith(activePath: path));
  }

  // Removes the layer a file stands for. Undo brings it back.
  void removeFile(String path) {
    final index = _layerOfPath[path];
    if (index == null) return;
    final layers = _editor.state.drawing.layers;
    if (layers.length > 1) {
      _editor.add(LayerDeleted(index));
      return;
    }
    _editor.add(CodeApplied([layers.first.copyWith(shapes: const <Shape>[])]));
  }

  void undo() => _editor.add(const UndoRequested());

  // Records the editor's text for [path] and, after a pause, reads it.
  void edit(String path, String content) {
    final file = state.fileAt(path);
    if (file == null || file.content == content) return;
    emit(state.copyWith(
      files: [for (final f in state.files) f.path == path ? f.withContent(content) : f],
    ));
    _editedPaths.add(path);
    _typingTimer?.cancel();
    _typingTimer = Timer(_typingPause, _applyEdits);
  }

  void _onEditorChanged(EditorState editorState) {
    if (editorState.drawing == _knownDrawing) return;
    _knownDrawing = editorState.drawing;
    _regenerate(_knownDrawing);
  }

  void _regenerate(Drawing drawing) {
    final exporter = DartExporter(drawing, options: _options);
    final files = exporter.generate();
    _layerOfPath = exporter.layerIndexByPath;
    final keep = state.activePath;
    final stillThere = files.any((file) => file.path == keep);
    emit(InlineCodeState(
      files: files,
      removablePaths: _layerOfPath.keys.toSet(),
      activePath: stillThere ? keep : (files.isEmpty ? null : files.first.path),
      status: state.status,
      skippedCount: state.skippedCount,
    ));
  }

  void _applyEdits() {
    final drawing = _editor.state.drawing;
    final palette = readPalette(state.files.map((file) => file.content));
    final size = Size(drawing.width, drawing.height);
    final paletteEdited = _editedPaths.any((path) => path.endsWith('_palette.dart'));
    final layers = [...drawing.layers];
    final unclaimed = <Shape>[];
    var layerName = '';
    var skipped = 0;
    var unreadable = false;
    for (final file in state.files) {
      final index = _layerOfPath[file.path];
      final edited = _editedPaths.contains(file.path) ||
          (paletteEdited && index != null);
      if (!edited) continue;
      final result = importCode(file.content, palette: palette, canvasSize: size);
      if (!result.isReadable) {
        unreadable = true;
        continue;
      }
      skipped += result.skipped;
      if (index != null) {
        layers[index] = layers[index].copyWith(shapes: result.shapes);
      } else if (result.shapes.isNotEmpty) {
        unclaimed.addAll(result.shapes);
        layerName = result.layerName;
      }
    }
    _editedPaths.clear();
    final promoted = unclaimed.isNotEmpty;
    if (promoted) _placeUnclaimed(layers, unclaimed, layerName);
    emit(state.copyWith(
      status: unreadable ? InlineCodeStatus.unreadable : InlineCodeStatus.rendered,
      skippedCount: skipped,
    ));
    final changed = layers.length != drawing.layers.length ||
        Drawing(name: drawing.name, layers: layers) !=
            Drawing(name: drawing.name, layers: drawing.layers);
    if (!changed) return;
    _knownDrawing = drawing.copyWith(layers: layers);
    _editor.add(CodeApplied(layers));
    if (promoted) _regenerate(_knownDrawing);
  }

  // Shapes drawn directly in the painter file (for example pasted code) become
  // a layer: the first one when the drawing is still empty, else a new one on
  // top. Regenerating then moves them into a layer file of their own.
  void _placeUnclaimed(List<PaintLayer> layers, List<Shape> shapes, String name) {
    final empty = layers.every((layer) => layer.shapes.isEmpty);
    if (empty && layers.first.image == null) {
      layers[0] = layers.first.copyWith(shapes: shapes);
      return;
    }
    layers.add(PaintLayer(name: name.isEmpty ? 'Code' : name, shapes: shapes));
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    _subscription.cancel();
    return super.close();
  }
}
