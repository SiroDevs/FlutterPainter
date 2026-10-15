// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/logic/exports.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension EditCommands on WorkspaceCommands {
  AppCommand get undo => AppCommand(
        label: 'Undo',
        icon: Icons.undo,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyZ),
        onPressed: state.canUndo ? () => send(const UndoRequested()) : null,
      );

  AppCommand get redo => AppCommand(
        label: 'Redo',
        icon: Icons.redo,
        shortcut: isMacOS
            ? primaryShortcut(LogicalKeyboardKey.keyZ, shift: true)
            : primaryShortcut(LogicalKeyboardKey.keyY),
        onPressed: state.canRedo ? () => send(const RedoRequested()) : null,
      );

  AppCommand get duplicate => AppCommand(
        label: 'Duplicate',
        icon: Icons.content_copy,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyD),
        onPressed: hasShape ? () => send(const ShapeDuplicated()) : null,
      );

  AppCommand get delete => AppCommand(
        label: 'Delete',
        icon: Icons.delete_outline,
        tooltip: 'Delete the selected shape or image',
        keys: 'Del',
        onPressed: (hasShape || state.imageSelected)
            ? () => send(const ShapeDeleted())
            : null,
      );

  AppCommand get bringForward => AppCommand(
        label: 'Bring forward',
        icon: Icons.flip_to_front,
        onPressed: hasShape ? () => send(const ShapeReordered(1)) : null,
      );

  AppCommand get sendBackward => AppCommand(
        label: 'Send backward',
        icon: Icons.flip_to_back,
        onPressed: hasShape ? () => send(const ShapeReordered(-1)) : null,
      );

  AppCommand get closedPath {
    final shape = state.selectedShape;
    return AppCommand(
      label: 'Closed path',
      icon: Icons.polyline_outlined,
      tooltip: 'Close or open the selected polygon / line path',
      checked: shape?.isClosed ?? false,
      onPressed: (shape != null && shape.usesVertices)
          ? () => send(ClosedToggled(!shape.isClosed))
          : null,
    );
  }

  AppCommand get fillOn => AppCommand(
        label: 'Fill',
        icon: Icons.format_color_fill,
        checked: state.style.fillOn,
        onPressed: () => send(FillToggled(!state.style.fillOn)),
      );

  AppCommand get strokeOn => AppCommand(
        label: 'Outline',
        icon: Icons.border_color,
        tooltip: 'Stroke (outline)',
        checked: state.style.strokeOn,
        onPressed: () => send(StrokeToggled(!state.style.strokeOn)),
      );
}
