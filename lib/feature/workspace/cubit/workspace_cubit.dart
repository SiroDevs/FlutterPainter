// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../common/constants/pref_constants.dart';
import '../../../core/utils/app_util.dart';
import '../../../domain/models/draft.dart';
import '../../../domain/models/drawing.dart';
import '../../../domain/repos/draft_repo.dart';
import '../../../domain/repos/prefs_repo.dart';
import '../../../domain/repos/project_repo.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/bloc/editor_bloc_factory.dart';
import '../../editor/logic/editor_ops.dart';
import '../../editor/models/editor_seed.dart';
import 'project_saver.dart';

part 'workspace_state.dart';

part 'workspace_cubit.freezed.dart';

/// The set of open projects (tabs) and the rules for keeping their work safe.
///
/// - Every edit schedules a write of a side copy (draft), so nothing is lost.
/// - With auto-save on, edits go straight into the project's own file instead,
///   once that file has been confirmed as safe to overwrite.
/// - [commitSave] promotes the latest state into the real file and removes the
///   side copy.
@lazySingleton
class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit(
    this._projects,
    this._drafts,
    this._saver,
    this._prefs,
    this._factory,
  )
      : super(const WorkspaceState());

  final ProjectRepo _projects;
  final DraftRepo _drafts;
  final ProjectSaver _saver;
  final PrefsRepo _prefs;
  final EditorBlocFactory _factory;

  final List<EditorBloc> _editors = [];
  final Map<EditorBloc, StreamSubscription<EditorState>> _subs = {};
  final Map<EditorBloc, Timer> _timers = {};
  final Map<EditorBloc, int> _seen = {};
  int _untitled = 0;

  List<EditorBloc> get editors => List.unmodifiable(_editors);

  /// The tab being edited. There is always at least one once [init] has run.
  EditorBloc get current =>
      _editors[state.active.clamp(0, _editors.length - 1).toInt()];

  void init() {
    emit(state.copyWith(autoSave: _prefs.getPrefBool(PrefConstants.autoSaveKey)));
    if (_editors.isEmpty) addBlank();
  }

  // ---- tabs ----------------------------------------------------------------

  EditorBloc addBlank() => addDrawing(Drawing(name: _nextUntitled()));

  EditorBloc addDrawing(Drawing drawing, {String? path, bool recovered = false, String? tabId}) =>
      _addTab(EditorSeed(
        tabId: tabId ?? newTabId(),
        drawing: drawing,
        filePath: path,
        recovered: recovered,
      ));

  EditorBloc restore(Draft d) =>
      addDrawing(d.drawing, path: d.path, recovered: true, tabId: d.tabId);

  /// Opens a project file in a new tab, or switches to the tab already showing it.
  Future<void> openProject(String path) async {
    final existing = _tabFor(path);
    if (existing != null) return activate(_editors.indexOf(existing));
    addDrawing(await _projects.open(path), path: path);
  }

  void activate(int i) {
    if (i < 0 || i >= _editors.length) return;
    emit(state.copyWith(active: i));
  }

  /// Closes a tab and discards its side copy. Callers handle save prompts.
  /// Closing the last tab leaves a fresh blank one so the editor is never empty.
  Future<void> removeTab(EditorBloc bloc) async {
    final i = _editors.indexOf(bloc);
    if (i < 0) return;
    _editors.removeAt(i);
    _timers.remove(bloc)?.cancel();
    await _subs.remove(bloc)?.cancel();
    _seen.remove(bloc);
    await _drafts.delete(bloc.state.tabId);
    if (_editors.isEmpty) {
      addBlank();
    } else {
      final active = i < state.active ? state.active - 1 : state.active;
      emit(state.copyWith(active: active.clamp(0, _editors.length - 1).toInt()));
      _syncTabs();
    }
    // Close after the frame so widgets still showing it can unsubscribe first.
    WidgetsBinding.instance.addPostFrameCallback((_) => bloc.close());
  }

  /// Startup: drop the initial blank tab if other projects were opened.
  void dropPristineFirstTab() {
    if (_editors.length > 1 && _editors.first.state.isPristine) {
      removeTab(_editors.first);
    }
  }

  String _nextUntitled() {
    _untitled++;
    return _untitled == 1 ? 'Untitled' : 'Untitled $_untitled';
  }

  EditorBloc? _tabFor(String path) {
    for (final b in _editors) {
      if (b.state.filePath == path) return b;
    }
    return null;
  }

  EditorBloc _addTab(EditorSeed seed) {
    final bloc = _factory.create(seed);
    _editors.add(bloc);
    _seen[bloc] = bloc.state.revision;
    _subs[bloc] = bloc.stream.listen((s) => _onEditorChanged(bloc, s));
    emit(state.copyWith(active: _editors.length - 1));
    _syncTabs();
    return bloc;
  }

  void _syncTabs() => emit(state.copyWith(
        tabs: [
          for (final b in _editors)
            TabInfo(
              id: b.state.tabId,
              title: b.state.drawing.name,
              path: b.state.filePath,
              dirty: b.state.dirty,
            ),
        ],
      ));

  // ---- keeping work safe -------------------------------------------------

  Future<void> setAutoSave(bool on) async {
    _prefs.setPrefBool(PrefConstants.autoSaveKey, on);
    emit(state.copyWith(autoSave: on));
    if (on) {
      for (final b in List.of(_editors)) {
        await persist(b);
      }
    }
  }

  void _onEditorChanged(EditorBloc bloc, EditorState s) {
    _syncTabs();
    if (s.revision == _seen[bloc]) return;
    _seen[bloc] = s.revision;
    _timers[bloc]?.cancel();
    _timers[bloc] = Timer(const Duration(milliseconds: 900), () => persist(bloc));
  }

  /// Writes the tab's pending work somewhere safe: its own file if auto-save is
  /// on and allowed, otherwise the side copy.
  Future<void> persist(EditorBloc bloc) async {
    _timers.remove(bloc)?.cancel();
    if (!_editors.contains(bloc) || bloc.isClosed) return;
    final s = bloc.state;
    if (!s.dirty) {
      await _drafts.delete(s.tabId);
    } else if (state.autoSave && s.filePath != null && s.overwriteConfirmed) {
      await commitSave(bloc, s.filePath!);
    } else {
      await _saver.writeDraft(s);
    }
  }

  /// Saves the tab to [path] (see [ProjectSaver.save]) and refreshes the tabs.
  Future<void> commitSave(EditorBloc bloc, String path, {String? name}) async {
    _timers.remove(bloc)?.cancel();
    await _saver.save(bloc, path, name: name);
    _syncTabs();
  }

  Future<List<Draft>> pendingDrafts() => _drafts.pending();

  Future<void> discardDraft(String tabId) => _drafts.delete(tabId);

  @override
  Future<void> close() async {
    for (final t in _timers.values) {
      t.cancel();
    }
    for (final s in _subs.values) {
      await s.cancel();
    }
    return super.close();
  }
}
