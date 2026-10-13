// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/draft.dart';
import '../../../domain/repos/draft_repo.dart';
import '../../../domain/repos/project_repo.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/editor_ops.dart';

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
  Future<void> save(EditorBloc bloc, String path, {String? name}) async {
    final drawing = bloc.state.drawing;
    await _projects.save(path, name == null ? drawing : drawing.copyWith(name: name));
    if (name != null) bloc.add(DrawingRenamed(name));
    bloc.add(DocumentSaved(path));
    await _settled(bloc, path);
    await _drafts.delete(bloc.state.tabId);
  }

  Future<void> writeDraft(EditorState s) => _drafts.save(Draft(
        tabId: s.tabId,
        path: s.filePath,
        drawing: s.drawing,
        savedAt: DateTime.now(),
      ));

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