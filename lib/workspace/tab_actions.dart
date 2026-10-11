// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/layer_ops.dart';
import '../editor/reference_ops.dart';
import '../model/drawing.dart';
import '../storage/flp_file.dart';
import '../ui/dialogs.dart';
import '../ui/file_dialogs.dart';
import 'workspace.dart';

/// The user-facing flows around tabs and files. They live apart from
/// [Workspace] because they show dialogs and need a [BuildContext].

Future<void> newRiderTab(Workspace ws) async {
  final text = await rootBundle.loadString('assets/templates/rider.json');
  ws.addTab(EditorController(drawing: Drawing.decode(text)));
}

Future<void> openProjectDialog(BuildContext context, Workspace ws) async {
  final paths = await pickProjectPaths();
  for (final path in paths) {
    if (!context.mounted) return;
    await openPath(context, ws, path);
  }
}

/// Opens a dropped or chosen file: a project opens in its own tab (or switches
/// to the tab already showing it); an image becomes the background reference.
Future<void> openPath(BuildContext context, Workspace ws, String path) async {
  try {
    if (isImageFile(path)) {
      final bytes = await pickBytes(path);
      await ws.current.setReferenceBytes(bytes);
      return;
    }
    if (!isProjectFile(path)) {
      if (context.mounted) toast(context, 'Not a Flutter Painter project: $path');
      return;
    }
    final existing = ws.tabForPath(path);
    if (existing != null) {
      ws.activate(ws.tabs.indexOf(existing));
      return;
    }
    ws.addTab(EditorController(drawing: await readFlp(path), filePath: path));
  } catch (e) {
    if (context.mounted) toast(context, 'Could not open $path: $e');
  }
}

/// Saves [c]. Returns false if the user cancelled.
///
/// - A project never saved asks where to save.
/// - A project that was opened from disk asks, the first time, whether to
///   overwrite the original or save a new file.
Future<bool> saveTab(
  BuildContext context,
  Workspace ws,
  EditorController c, {
  bool saveAs = false,
}) async {
  String? target = c.filePath;
  if (saveAs || target == null) {
    target = await pickSavePath();
  } else if (!c.overwriteConfirmed) {
    switch (await askOverwrite(context, target)) {
      case OverwriteChoice.cancel:
        return false;
      case OverwriteChoice.saveNew:
        target = await pickSavePath();
      case OverwriteChoice.overwrite:
        break;
    }
  }
  if (target == null) return false;
  try {
    final wasUntitled = c.filePath == null && c.drawing.name.startsWith('Untitled');
    if (wasUntitled) c.renameDrawing(baseNameOf(target));
    await ws.commitSave(c, target);
    if (context.mounted) toast(context, 'Saved $target');
    return true;
  } catch (e) {
    if (context.mounted) toast(context, 'Could not save: $e');
    return false;
  }
}

/// Closes a tab, asking to save first if it has unsaved changes.
/// Returns false if the user cancelled.
Future<bool> closeTab(BuildContext context, Workspace ws, EditorController c) async {
  if (c.dirty) {
    ws.activate(ws.tabs.indexOf(c));
    switch (await askSaveChanges(context, c.drawing.name)) {
      case SaveChoice.cancel:
        return false;
      case SaveChoice.save:
        if (!context.mounted || !await saveTab(context, ws, c)) return false;
      case SaveChoice.discard:
        break;
    }
  }
  await ws.removeTab(c);
  return true;
}

/// Asks about every project with unsaved changes. False = the user cancelled.
Future<bool> confirmExit(BuildContext context, Workspace ws) async {
  for (final c in List.of(ws.tabs)) {
    if (!c.dirty) continue;
    if (!context.mounted || !await closeTab(context, ws, c)) return false;
  }
  return true;
}

/// Offers to bring back work that was left unsaved when the app last closed.
Future<void> recoverDrafts(BuildContext context, Workspace ws) async {
  final drafts = await ws.drafts.pending();
  if (drafts.isEmpty || !context.mounted) return;
  final restore = await askRecover(context, [for (final d in drafts) d.title]);
  for (final d in drafts) {
    if (restore) {
      ws.restore(d);
    } else {
      await ws.drafts.delete(d.tabId);
    }
  }
}

Future<void> chooseReferenceImage(BuildContext context, EditorController c) async {
  try {
    final bytes = await pickImageBytes();
    if (bytes != null) await c.setReferenceBytes(bytes);
  } catch (e) {
    if (context.mounted) toast(context, 'Could not load that image: $e');
  }
}
