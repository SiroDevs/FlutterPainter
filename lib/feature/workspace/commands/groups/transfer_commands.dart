// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/logic/drawing/editor_ops.dart';
import '../../clipboard/project_transfer_clipboard.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension TransferCommands on WorkspaceCommands {
  ProjectTransferClipboard get _clipboard => ProjectTransferClipboard.instance;
  bool get canCopyGroup {
    final shapes = state.selectedShapes;
    final id = shapes.isEmpty ? null : shapes.first.groupId;
    return id != null && shapes.every((shape) => shape.groupId == id);
  }

  AppCommand get copySelection => AppCommand(
    label: context.l10n.projectCopySelection,
    icon: Icons.content_copy,
    onPressed: state.validSelectedIndices.isEmpty
        ? null
        : () => _clipboard.copySelection(bloc.state),
  );

  AppCommand get copyGroup => AppCommand(
    label: context.l10n.shapeCopyGroup,
    icon: Icons.group_work_outlined,
    onPressed: canCopyGroup ? () => _clipboard.copyGroup(bloc.state) : null,
  );

  AppCommand get copyLayer => AppCommand(
    label: context.l10n.projectCopyLayer,
    icon: Icons.layers_outlined,
    onPressed: () => _clipboard.copyLayer(bloc.state.layer),
  );

  AppCommand get pasteTransfer => AppCommand(
    label: context.l10n.projectPaste,
    icon: Icons.content_paste,
    onPressed: _clipboard.value == null
        ? null
        : () => _clipboard.pasteInto(bloc),
  );

  AppCommand get flipHorizontal => AppCommand(
    label: context.l10n.shapeFlipHorizontal,
    icon: Icons.flip,
    onPressed: hasShape
        ? () => send(const SelectionFlipped(horizontal: true))
        : null,
  );

  AppCommand get flipVertical => AppCommand(
    label: context.l10n.shapeFlipVertical,
    icon: Icons.flip,
    onPressed: hasShape
        ? () => send(const SelectionFlipped(horizontal: false))
        : null,
  );
}
