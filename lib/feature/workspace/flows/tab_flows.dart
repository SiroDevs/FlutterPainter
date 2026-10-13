// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../common/widgets/progress/custom_snackbar.dart';
import '../../../core/di/injectable.dart';
import '../../../core/platform/file_dialogs.dart';
import '../../../core/utils/path_util.dart';
import '../../../domain/models/drawing.dart';
import '../../../data/mappers/drawing_mapper.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/editor_ops.dart';
import '../cubit/workspace_cubit.dart';

/// The user-facing flows around tabs and files. They live apart from the cubit
/// because they show dialogs and need a [BuildContext].

FileDialogs get _dialogs => getIt<FileDialogs>();

/// Starts a new project from the current RoadBash rider in its neutral pose.
Future<void> newRiderTab(WorkspaceCubit ws) async {
  final text = await rootBundle.loadString('assets/templates/rider.json');
  final Drawing drawing = drawingFromJson(text);
  ws.addDrawing(drawing);
}

Future<void> openProjectDialog(BuildContext context, WorkspaceCubit ws) async {
  final paths = await _dialogs.pickProjectPaths();
  for (final path in paths) {
    if (!context.mounted) return;
    await openPath(context, ws, path);
  }
}

/// Opens a dropped or chosen file: a project opens in its own tab (or switches
/// to the tab already showing it); an image becomes the background reference.
Future<void> openPath(BuildContext context, WorkspaceCubit ws, String path) async {
  try {
    if (isImageFile(path)) {
      final bytes = await _dialogs.readBytes(path);
      ws.current.add(ReferenceLoaded(bytes));
    } else if (isProjectFile(path)) {
      await ws.openProject(path);
    } else if (context.mounted) {
      CustomSnackbar.show(context, 'Not a Flutter Painter project: $path');
    }
  } catch (e) {
    if (context.mounted) CustomSnackbar.show(context, 'Could not open $path: $e');
  }
}

/// Saves [bloc]'s project. Returns false if the user cancelled.
///
/// - A project never saved asks where to save.
/// - A project that was opened from disk asks, the first time, whether to
///   overwrite the original or save a new file.
Future<bool> saveTab(
  BuildContext context,
  WorkspaceCubit ws,
  EditorBloc bloc, {
  bool saveAs = false,
}) async {
  final s = bloc.state;
  String? target = s.filePath;
  if (saveAs || target == null) {
    target = await _dialogs.pickSavePath();
  } else if (!s.overwriteConfirmed) {
    switch (await askOverwrite(context, target)) {
      case OverwriteChoice.cancel:
        return false;
      case OverwriteChoice.saveNew:
        target = await _dialogs.pickSavePath();
      case OverwriteChoice.overwrite:
        break;
    }
  }
  if (target == null) return false;
  try {
    final firstSave = s.filePath == null && s.drawing.name.startsWith('Untitled');
    await ws.commitSave(bloc, target, name: firstSave ? baseNameOf(target) : null);
    if (context.mounted) CustomSnackbar.show(context, 'Saved $target', isSuccess: true);
    return true;
  } catch (e) {
    if (context.mounted) CustomSnackbar.show(context, 'Could not save: $e');
    return false;
  }
}

/// Closes a tab, asking to save first if it has unsaved changes.
/// Returns false if the user cancelled.
Future<bool> closeTab(BuildContext context, WorkspaceCubit ws, EditorBloc bloc) async {
  if (bloc.state.dirty) {
    ws.activate(ws.editors.indexOf(bloc));
    switch (await askSaveChanges(context, bloc.state.drawing.name)) {
      case SaveChoice.cancel:
        return false;
      case SaveChoice.save:
        if (!context.mounted || !await saveTab(context, ws, bloc)) return false;
      case SaveChoice.discard:
        break;
    }
  }
  await ws.removeTab(bloc);
  return true;
}

/// Asks about every project with unsaved changes. False = the user cancelled.
Future<bool> confirmExit(BuildContext context, WorkspaceCubit ws) async {
  for (final bloc in ws.editors) {
    if (!bloc.state.dirty) continue;
    if (!context.mounted || !await closeTab(context, ws, bloc)) return false;
  }
  return true;
}

/// Offers to bring back work that was left unsaved when the app last closed.
Future<void> recoverDrafts(BuildContext context, WorkspaceCubit ws) async {
  final drafts = await ws.pendingDrafts();
  if (drafts.isEmpty || !context.mounted) return;
  final restore = await askRecover(context, [for (final d in drafts) d.title]);
  for (final d in drafts) {
    if (restore) {
      ws.restore(d);
    } else {
      await ws.discardDraft(d.tabId);
    }
  }
}
