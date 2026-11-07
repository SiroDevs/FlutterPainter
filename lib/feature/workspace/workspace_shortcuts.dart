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
    required this.isTyping,
  });

  final BuildContext context;
  final WorkspaceCubit workspace;
  final bool Function() isTyping;

  Map<ShortcutActivator, VoidCallback> bindings() {
    final shortcuts = <ShortcutActivator, VoidCallback>{};
    void both(LogicalKeyboardKey key, VoidCallback action, {bool shift = false}) {
      shortcuts[SingleActivator(key, control: true, shift: shift)] = action;
      shortcuts[SingleActivator(key, meta: true, shift: shift)] = action;
    }

    void send(EditorEvent event) => workspace.current.add(event);
    void zoom(double factor) {
      final viewport = workspace.current.state.view.viewport;
      send(
        ViewZoomed(
          factor,
          Offset(viewport.width / 2, viewport.height / 2),
        ),
      );
    }

    void guarded(VoidCallback action) {
      if (!isTyping()) action();
    }

    both(
      LogicalKeyboardKey.keyZ,
      () => guarded(() => send(const UndoRequested())),
    );
    both(
      LogicalKeyboardKey.keyZ,
      () => guarded(() => send(const RedoRequested())),
      shift: true,
    );
    both(
      LogicalKeyboardKey.keyY,
      () => guarded(() => send(const RedoRequested())),
    );
    both(
      LogicalKeyboardKey.keyD,
      () => guarded(() => send(const ShapeDuplicated())),
    );
    both(
      LogicalKeyboardKey.keyA,
      () => guarded(() => send(const SelectAllRequested())),
    );
    both(LogicalKeyboardKey.minus, () => guarded(() => zoom(1 / 1.25)));
    both(LogicalKeyboardKey.equal, () => guarded(() => zoom(1.25)));
    both(
      LogicalKeyboardKey.digit0,
      () => guarded(() => send(const FitRequested())),
    );
    both(
      LogicalKeyboardKey.keyS,
      () => guarded(() => saveTab(context, workspace, workspace.current)),
    );
    both(
      LogicalKeyboardKey.keyS,
      () => guarded(
        () => saveTab(context, workspace, workspace.current, saveAs: true),
      ),
      shift: true,
    );
    both(
      LogicalKeyboardKey.keyO,
      () => guarded(() => openProjectDialog(context, workspace)),
    );
    both(LogicalKeyboardKey.keyN, () => guarded(workspace.addBlank));
    both(
      LogicalKeyboardKey.keyW,
      () => guarded(() => closeTab(context, workspace, workspace.current)),
    );
    both(
      LogicalKeyboardKey.keyE,
      () => guarded(() => context.push(
        RoutePaths.export,
        extra: ExportArgs(workspace.current.state.drawing),
      )),
    );
    both(
      LogicalKeyboardKey.comma,
      () => guarded(() => showSettingsDialog(context)),
    );

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
    return shortcuts;
  }

  KeyEventResult handleEscape(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape ||
        isTyping() ||
        ModalRoute.of(context)?.isCurrent == false) {
      return KeyEventResult.ignored;
    }
    workspace.current.add(const ToolSelected(Tool.select));
    return KeyEventResult.handled;
  }
}
