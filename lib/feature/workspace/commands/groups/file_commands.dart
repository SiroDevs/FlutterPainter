// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../../common/app_router/route_names.dart';
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../editor/bloc/controller/editor_bloc.dart';
import '../../../export/export_args.dart';
import '../../../settings/widgets/settings_dialog.dart';
import '../../flows/tab_flows.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension FileCommands on WorkspaceCommands {
  AppCommand get newBlank => AppCommand(
    label: context.l10n.fileNewBlank,
    icon: Icons.note_add_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyN),
    onPressed: ws.addBlank,
  );

  AppCommand get open => AppCommand(
    label: context.l10n.fileOpen,
    icon: Icons.folder_open,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyO),
    onPressed: () => openProjectDialog(context, ws),
  );

  AppCommand get importProject => AppCommand(
    label: context.l10n.projectImport,
    icon: Icons.file_download_outlined,
    onPressed: () => importProjectDialog(context, bloc),
  );

  AppCommand get save => AppCommand(
    label: context.l10n.fileSave,
    icon: Icons.save_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyS),
    onPressed: () => saveTab(context, ws, bloc),
  );

  AppCommand get saveAs => AppCommand(
    label: context.l10n.fileSaveAs,
    icon: Icons.save_as_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyS, shift: true),
    onPressed: () => saveTab(context, ws, bloc, saveAs: true),
  );

  AppCommand get autoSave => AppCommand(
    label: context.l10n.fileAutoSave,
    icon: Icons.autorenew,
    tooltip: context.l10n.fileAutoSaveHelp,
    checked: autoSaveOn,
    onPressed: () => ws.setAutoSave(!autoSaveOn),
  );

  /// Opens the code editor as a page of its own, over the workspace.
  AppCommand get exportDart => AppCommand(
    label: context.l10n.fileExportDart,
    icon: Icons.code,
    tooltip: context.l10n.fileCodeEditorTooltip,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyE),
    onPressed: () =>
        context.push(RoutePaths.export, extra: ExportArgs(bloc.state.drawing)),
  );

  AppCommand get settings => AppCommand(
    label: context.l10n.fileSettings,
    icon: Icons.settings_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.comma),
    onPressed: () => showSettingsDialog(context),
  );

  AppCommand get rename => AppCommand(
    label: context.l10n.fileRenameProject,
    icon: Icons.edit_outlined,
    tooltip: context.l10n.projectNameTooltip,
    onPressed: () async {
      final name = await promptText(
        context,
        title: context.l10n.projectNameTooltip,
        initial: bloc.state.drawing.name,
      );
      if (name != null && name.isNotEmpty) send(DrawingRenamed(name));
    },
  );

  AppCommand get canvasSize => AppCommand(
    label: context.l10n.fileCanvasSize,
    icon: Icons.aspect_ratio,
    onPressed: () async {
      final d = bloc.state.drawing;
      final size = await promptSize(context, d.width, d.height);
      if (size != null) send(CanvasResized(size.$1, size.$2));
    },
  );

  AppCommand get closeProject => AppCommand(
    label: context.l10n.fileCloseProject,
    icon: Icons.close,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyW),
    onPressed: () => closeTab(context, ws, bloc),
  );

  /// Quits through the normal exit request, so unsaved work is still asked
  /// about. (macOS has its own Quit item in the application menu.)
  AppCommand get exitApp => AppCommand(
    label: context.l10n.fileExit,
    icon: Icons.exit_to_app,
    onPressed: () =>
        ServicesBinding.instance.exitApplication(AppExitType.cancelable),
  );
}
