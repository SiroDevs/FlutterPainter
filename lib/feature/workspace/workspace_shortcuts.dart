// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../domain/models/tool.dart';
import '../editor/bloc/editor_bloc.dart';
import '../editor/widgets/toolbar/tool_info.dart';
import '../export/export_args.dart';
import '../settings/widgets/settings_dialog.dart';
import 'cubit/workspace_cubit.dart';
import 'flows/tab_flows.dart';

/// Shortcuts available while the workspace has keyboard focus.
class WorkspaceShortcuts {
  const WorkspaceShortcuts({
    required this.context,
    required this.workspace,
    required this.editor,
    required this.isTyping,
  });

  final BuildContext context;
  final WorkspaceCubit workspace;
  final EditorBloc editor;
  final bool Function() isTyping;

  Map<ShortcutActivator, VoidCallback> bindings() {
    final shortcuts = <ShortcutActivator, VoidCallback>{};
    void both(LogicalKeyboardKey key, VoidCallback action, {bool shift = false}) {
      shortcuts[SingleActivator(key, control: true, shift: shift)] = action;
      shortcuts[SingleActivator(key, meta: true, shift: shift)] = action;
    }

    void send(EditorEvent event) => editor.add(event);
    void guarded(VoidCallback action) {
      if (!isTyping()) action();
    }

    both(LogicalKeyboardKey.keyZ, () => guarded(() => send(const UndoRequested())));
    both(LogicalKeyboardKey.keyZ, () => guarded(() => send(const RedoRequested())), shift: true);
    both(LogicalKeyboardKey.keyY, () => guarded(() => send(const RedoRequested())));
    both(LogicalKeyboardKey.keyD, () => guarded(() => send(const ShapeDuplicated())));
    both(LogicalKeyboardKey.keyA, () => guarded(() => send(const SelectAllRequested())));
    both(LogicalKeyboardKey.keyS, () => guarded(() => saveTab(context, workspace, editor)));
    both(
      LogicalKeyboardKey.keyS,
      () => guarded(() => saveTab(context, workspace, editor, saveAs: true)),
      shift: true,
    );
    both(LogicalKeyboardKey.keyO, () => guarded(() => openProjectDialog(context, workspace)));
    both(LogicalKeyboardKey.keyN, () => guarded(workspace.addBlank));
    both(LogicalKeyboardKey.keyW, () => guarded(() => closeTab(context, workspace, editor)));
    both(
      LogicalKeyboardKey.keyE,
      () => guarded(() => context.push(
        RoutePaths.export,
        extra: ExportArgs(editor.state.drawing),
      )),
    );
    both(LogicalKeyboardKey.comma, () => guarded(() => showSettingsDialog(context)));

    for (final tool in Tool.values) {
      shortcuts[SingleActivator(tool.shortcutKey)] =
          () => guarded(() => send(ToolSelected(tool)));
    }
    shortcuts[const SingleActivator(LogicalKeyboardKey.delete)] =
        () => guarded(() => send(const ShapeDeleted()));
    shortcuts[const SingleActivator(LogicalKeyboardKey.backspace)] =
        () => guarded(() => send(const ShapeDeleted()));
    shortcuts[const SingleActivator(LogicalKeyboardKey.enter)] =
        () => guarded(() => send(const PolygonFinished(closed: false)));
    shortcuts[const SingleActivator(LogicalKeyboardKey.enter, shift: true)] =
        () => guarded(() => send(const PolygonFinished()));
    shortcuts[const SingleActivator(LogicalKeyboardKey.escape)] = () => guarded(() {
      send(const DraftCancelled());
      send(const ToolSelected(Tool.select));
    });
    return shortcuts;
  }
}
