// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../domain/models/editor/tool.dart';
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

  KeyEventResult handleKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent ||
        isTyping() ||
        ModalRoute.of(context)?.isCurrent == false) {
      return KeyEventResult.ignored;
    }
    final keyboard = HardwareKeyboard.instance;
    final key = event.logicalKey;
    final primary = keyboard.isControlPressed || keyboard.isMetaPressed;
    if (primary && keyboard.isAltPressed) return KeyEventResult.ignored;

    if (primary) return _handlePrimaryKey(key, keyboard.isShiftPressed);
    if (keyboard.isAltPressed || keyboard.isMetaPressed ||
        keyboard.isControlPressed) {
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.escape) {
      workspace.current.add(const ToolSelected(Tool.select));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.delete ||
        key == LogicalKeyboardKey.backspace) {
      workspace.current.add(const ShapeDeleted());
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter) {
      workspace.current.add(
        PolygonFinished(closed: keyboard.isShiftPressed),
      );
      return KeyEventResult.handled;
    }
    if (!keyboard.isShiftPressed) {
      for (final tool in Tool.values) {
        if (key == tool.shortcutKey) {
          workspace.current.add(ToolSelected(tool));
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handlePrimaryKey(LogicalKeyboardKey key, bool shift) {
    final editor = workspace.current;
    switch (key) {
      case LogicalKeyboardKey.keyZ:
        editor.add(shift ? const RedoRequested() : const UndoRequested());
        break;
      case LogicalKeyboardKey.keyY when !shift:
        editor.add(const RedoRequested());
        break;
      case LogicalKeyboardKey.keyD when !shift:
        editor.add(const ShapeDuplicated());
        break;
      case LogicalKeyboardKey.keyA when !shift:
        editor.add(const SelectAllRequested());
        break;
      case LogicalKeyboardKey.minus when !shift:
        _zoom(1 / 1.25);
        break;
      case LogicalKeyboardKey.equal when !shift:
        _zoom(1.25);
        break;
      case LogicalKeyboardKey.digit0 when !shift:
        editor.add(const FitRequested());
        break;
      case LogicalKeyboardKey.keyS:
        saveTab(context, workspace, editor, saveAs: shift);
        break;
      case LogicalKeyboardKey.keyO when !shift:
        openProjectDialog(context, workspace);
        break;
      case LogicalKeyboardKey.keyN when !shift:
        workspace.addBlank();
        break;
      case LogicalKeyboardKey.keyW when !shift:
        closeTab(context, workspace, editor);
        break;
      case LogicalKeyboardKey.keyE when !shift:
        context.push(
          RoutePaths.export,
          extra: ExportArgs(editor.state.drawing),
        );
        break;
      case LogicalKeyboardKey.comma when !shift:
        showSettingsDialog(context);
        break;
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _zoom(double factor) {
    final viewport = workspace.current.state.view.viewport;
    workspace.current.add(
      ViewZoomed(
        factor,
        Offset(viewport.width / 2, viewport.height / 2),
      ),
    );
  }
}
