// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../model/drawing.dart';
import '../storage/app_settings.dart';
import '../storage/draft_store.dart';
import '../storage/flp_file.dart';

/// The set of open projects (tabs) and the rules for keeping their work safe.
///
/// - Every edit schedules a write of a side copy (draft), so nothing is lost.
/// - With auto-save on, edits go straight into the project's own file instead,
///   once that file has been confirmed as safe to overwrite.
/// - [commitSave] promotes the latest state into the real file and removes the
///   side copy.
class Workspace extends ChangeNotifier {
  Workspace({DraftStore? drafts, AppSettings? settings})
      : drafts = drafts ?? DraftStore(),
        settings = settings ?? AppSettings();

  final DraftStore drafts;
  final AppSettings settings;
  final List<EditorController> tabs = [];
  int active = 0;

  final Map<EditorController, VoidCallback> _listeners = {};
  final Map<EditorController, Timer> _timers = {};
  final Map<EditorController, int> _seen = {};
  int _untitled = 0;

  /// The tab being edited. There is always at least one.
  EditorController get current => tabs[active.clamp(0, tabs.length - 1).toInt()];

  bool get autoSave => settings.autoSave;

  Future<void> init() async {
    await settings.load();
    notifyListeners();
  }

  Future<void> setAutoSave(bool on) async {
    settings.autoSave = on;
    await settings.save();
    notifyListeners();
    if (on) {
      for (final c in List.of(tabs)) {
        await persist(c);
      }
    }
  }

  String nextUntitledName() {
    _untitled++;
    return _untitled == 1 ? 'Untitled' : 'Untitled $_untitled';
  }

  EditorController? tabForPath(String path) {
    for (final c in tabs) {
      if (c.filePath == path) return c;
    }
    return null;
  }

  EditorController addTab(EditorController c, {bool activate = true}) {
    tabs.add(c);
    _seen[c] = c.revision;
    void listener() => _onChanged(c);
    _listeners[c] = listener;
    c.addListener(listener);
    if (activate) active = tabs.length - 1;
    notifyListeners();
    return c;
  }

  EditorController addBlank() => addTab(
        EditorController(drawing: Drawing(name: nextUntitledName())),
      );

  void activate(int i) {
    if (i < 0 || i >= tabs.length) return;
    active = i;
    notifyListeners();
  }

  /// Closes a tab and discards its side copy. Callers handle save prompts.
  /// Closing the last tab leaves a fresh blank one so the editor is never empty.
  Future<void> removeTab(EditorController c) async {
    final i = tabs.indexOf(c);
    if (i < 0) return;
    tabs.removeAt(i);
    _timers.remove(c)?.cancel();
    final l = _listeners.remove(c);
    if (l != null) c.removeListener(l);
    _seen.remove(c);
    await drafts.delete(c.tabId);
    if (tabs.isEmpty) {
      addBlank();
    } else {
      if (i < active) active--;
      active = active.clamp(0, tabs.length - 1).toInt();
      notifyListeners();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => c.dispose());
  }

  /// Startup: drop the initial blank tab if other projects were opened.
  void dropPristineFirstTab() {
    if (tabs.length > 1 && tabs.first.isPristine) {
      removeTab(tabs.first);
    }
  }

  EditorController restore(Draft d) {
    final c = EditorController(drawing: d.drawing, tabId: d.tabId, filePath: d.path);
    c.markUnsaved();
    return addTab(c);
  }

  void _onChanged(EditorController c) {
    if (c.revision == _seen[c]) return;
    _seen[c] = c.revision;
    _timers[c]?.cancel();
    _timers[c] = Timer(const Duration(milliseconds: 900), () => persist(c));
  }

  /// Writes the tab's pending work somewhere safe: its own file if auto-save is
  /// on and allowed, otherwise the side copy.
  Future<void> persist(EditorController c) async {
    _timers.remove(c)?.cancel();
    if (c.disposed || !tabs.contains(c)) return;
    if (!c.dirty) {
      await drafts.delete(c.tabId);
    } else if (autoSave && c.filePath != null && c.overwriteConfirmed) {
      await commitSave(c, c.filePath!);
    } else {
      await drafts.write(c);
    }
  }

  /// Writes the latest state into [path] atomically, then clears the side copy.
  Future<void> commitSave(EditorController c, String path) async {
    _timers.remove(c)?.cancel();
    await writeFlp(path, c.drawing);
    c.filePath = path;
    c.overwriteConfirmed = true;
    c.markSaved();
    await drafts.delete(c.tabId);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    super.dispose();
  }
}
