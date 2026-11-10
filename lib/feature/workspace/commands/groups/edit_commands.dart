// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
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
    label: context.l10n.shapeDuplicate,
    icon: Icons.content_copy,
    shortcut: primaryShortcut(LogicalKeyboardKey.keyD),
    onPressed: hasShape ? () => send(const ShapeDuplicated()) : null,
  );

  AppCommand get delete => AppCommand(
    label: context.l10n.shapeDelete,
    icon: Icons.delete_outline,
    tooltip: 'Delete the selected shape or image',
    keys: 'Del',
    onPressed: (hasShape || state.imageSelected)
        ? () => send(const ShapeDeleted())
        : null,
  );

  AppCommand get bringForward => AppCommand(
    label: context.l10n.shapeBringForward,
    icon: Icons.arrow_upward,
    shortcut: primaryShortcut(LogicalKeyboardKey.arrowUp),
    onPressed: canBringForward ? () => send(const ShapeReordered(1)) : null,
  );

  AppCommand get sendBackward => AppCommand(
    label: context.l10n.shapeSendBackward,
    icon: Icons.arrow_downward,
    shortcut: primaryShortcut(LogicalKeyboardKey.arrowDown),
    onPressed: canSendBackward ? () => send(const ShapeReordered(-1)) : null,
  );

  AppCommand get bringToFront => AppCommand(
    label: context.l10n.shapeBringToFront,
    icon: Icons.flip_to_front,
    onPressed: canBringToFront
        ? () => send(const ShapeReordered(1, toExtreme: true))
        : null,
  );

  AppCommand get sendToBack => AppCommand(
    label: context.l10n.shapeSendToBack,
    icon: Icons.flip_to_back,
    onPressed: canSendToBack
        ? () => send(const ShapeReordered(-1, toExtreme: true))
        : null,
  );

  AppCommand get group => AppCommand(
    label: context.l10n.shapeGroup,
    icon: Icons.group_work_outlined,
    tooltip: context.l10n.shapeGroupTooltip,
    onPressed: canGroup ? () => send(const ShapesGrouped()) : null,
  );

  AppCommand get ungroup => AppCommand(
    label: context.l10n.shapeUngroup,
    icon: Icons.workspaces_outline,
    tooltip: context.l10n.shapeUngroupTooltip,
    onPressed: hasGroupedSelection ? () => send(const ShapesUngrouped()) : null,
  );

  AppCommand get closedPath {
    final shape = state.selectedShape;
    return AppCommand(
      label: context.l10n.shapeClosedPath,
      icon: Icons.polyline_outlined,
      tooltip: 'Close or open the selected polygon / line path',
      checked: shape?.isClosed ?? false,
      onPressed:
          (shape != null &&
              shape.usesVertices &&
              state.validSelectedIndices.length == 1)
          ? () => send(ClosedToggled(!shape.isClosed))
          : null,
    );
  }

  AppCommand get scaleDown => AppCommand(
    label: context.l10n.shapeScaleDown,
    icon: Icons.zoom_out_map,
    onPressed: state.validSelectedIndices.isNotEmpty
        ? () => send(const SelectionScaled(0.9))
        : null,
  );

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
