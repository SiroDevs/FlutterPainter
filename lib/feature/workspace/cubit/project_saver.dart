// Dart imports:
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/utils/path_util.dart';
import '../../../domain/models/drawing/draft.dart';
import '../../../domain/models/export/export_options.dart';
import '../../../domain/repos/draft_repo.dart';
import '../../../domain/repos/project_repo.dart';
import '../../../domain/services/code_export/dart_exporter.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/drawing/editor_ops.dart';

/// Writes a tab to disk: the real file on save, or a side copy while it has
/// unsaved changes.
@lazySingleton
class ProjectSaver {
  ProjectSaver(this._projects, this._drafts);

  final ProjectRepo _projects;
  final DraftRepo _drafts;

  /// Writes the latest state into [path] atomically, tells the editor it was
  /// saved, and removes the side copy. [name] renames the project in the same
  /// step (used for a first save).
  Future<String> save(
    EditorBloc bloc,
    String path, {
    String? name,
    required ExportOptions options,
  }) async {
    final sourcePath = bloc.state.filePath;
    final targetPath = _projectPath(path);
    final drawing = name == null
        ? bloc.state.drawing
        : bloc.state.drawing.copyWith(name: name);
    final codeFiles = DartExporter(drawing, options: options).generate();
    await _projects.saveBundle(targetPath, drawing, codeFiles);
    if (name != null) bloc.add(DrawingRenamed(name));
    bloc.add(DocumentSaved(targetPath));
    await _settled(bloc, targetPath);
    if (sourcePath == path && sourcePath != targetPath) {
      await _projects.delete(sourcePath!);
    }
    await _drafts.delete(bloc.state.tabId);
    return targetPath;
  }

  String _projectPath(String path) {
    final fileName = path.split(RegExp(r'[\\/]')).last;
    final folderName = baseNameOf(path);
    final parent = File(path).parent.path;
    final parentName = parent.split(RegExp(r'[\\/]')).last;
    if (parentName == folderName) return path;
    return _join(_join(parent, folderName), fileName);
  }

  String _join(String parent, String child) {
    if (parent.endsWith(Platform.pathSeparator)) return '$parent$child';
    return '$parent${Platform.pathSeparator}$child';
  }

  Future<void> writeDraft(EditorState s) => _drafts.save(
    Draft(
      tabId: s.tabId,
      path: s.filePath,
      drawing: s.drawing,
      savedAt: DateTime.now(),
    ),
  );

  /// Waits for the editor to report the save (events are handled asynchronously).
  Future<void> _settled(EditorBloc bloc, String path) async {
    bool done(EditorState s) =>
        s.filePath == path && s.overwriteConfirmed && !s.dirty;
    if (done(bloc.state)) return;
    await bloc.stream
        .firstWhere(done)
        .timeout(const Duration(seconds: 2), onTimeout: () => bloc.state);
  }
}
