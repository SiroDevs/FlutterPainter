// Flutter imports:
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../../common/app_router/route_names.dart';
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../export/export_args.dart';
import '../../../settings/widgets/settings_dialog.dart';
import '../../flows/tab_flows.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension FileCommands on WorkspaceCommands {
  AppCommand get newBlank => AppCommand(
    label: 'New blank canvas',
    icon: Icons.note_add_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyN),
    onPressed: ws.addBlank,
  );

  AppCommand get newRider => AppCommand(
    label: 'RoadBash rider',
    icon: Icons.two_wheeler,
    tooltip: 'New project from the RoadBash rider template',
    onPressed: () => newRiderTab(ws),
  );

  AppCommand get open => AppCommand(
    label: 'Open…',
    icon: Icons.folder_open,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyO),
    onPressed: () => openProjectDialog(context, ws),
  );

  AppCommand get save => AppCommand(
    label: 'Save',
    icon: Icons.save_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyS),
    onPressed: () => saveTab(context, ws, bloc),
  );

  AppCommand get saveAs => AppCommand(
    label: 'Save as…',
    icon: Icons.save_as_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyS, shift: true),
    onPressed: () => saveTab(context, ws, bloc, saveAs: true),
  );

  AppCommand get autoSave => AppCommand(
    label: 'Auto-save',
    icon: Icons.autorenew,
    tooltip:
        'Auto-save: write changes straight into the open .flp file. '
        'Off: changes go to a safe side copy until you press Save.',
    checked: autoSaveOn,
    onPressed: () => ws.setAutoSave(!autoSaveOn),
  );

  /// Opens the code editor as a page of its own, over the workspace.
  AppCommand get exportDart => AppCommand(
    label: 'Export Dart…',
    icon: Icons.code,
    tooltip: 'Open the code editor',
    shortcut: primaryShortcut(LogicalKeyboardKey.keyE),
    onPressed: () =>
        context.push(RoutePaths.export, extra: ExportArgs(bloc.state.drawing)),
  );

  AppCommand get settings => AppCommand(
    label: 'Settings…',
    icon: Icons.settings_outlined,
    shortcut: primaryShortcut(LogicalKeyboardKey.comma),
    onPressed: () => showSettingsDialog(context),
  );

  AppCommand get rename => AppCommand(
    label: 'Rename project…',
    icon: Icons.edit_outlined,
    tooltip: 'Project name (also used for class names)',
    onPressed: () async {
      final name = await promptText(
        context,
        title: 'Project name (also used for class names)',
        initial: bloc.state.drawing.name,
      );
      if (name != null && name.isNotEmpty) send(DrawingRenamed(name));
    },
  );

  AppCommand get canvasSize => AppCommand(
    label: 'Canvas size…',
    icon: Icons.aspect_ratio,
    onPressed: () async {
      final d = bloc.state.drawing;
      final size = await promptSize(context, d.width, d.height);
      if (size != null) send(CanvasResized(size.$1, size.$2));
    },
  );

  AppCommand get closeProject => AppCommand(
    label: 'Close project',
    icon: Icons.close,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyW),
    onPressed: () => closeTab(context, ws, bloc),
  );

  /// Quits through the normal exit request, so unsaved work is still asked
  /// about. (macOS has its own Quit item in the application menu.)
  AppCommand get exitApp => AppCommand(
    label: 'Exit',
    icon: Icons.exit_to_app,
    onPressed: () =>
        ServicesBinding.instance.exitApplication(AppExitType.cancelable),
  );
}
