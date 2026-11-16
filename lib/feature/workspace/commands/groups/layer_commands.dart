// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/logic/exports.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension LayerCommands on WorkspaceCommands {
  AppCommand get layerAdd => AppCommand(
    label: context.l10n.layerAdd,
    icon: Icons.add_box_outlined,
    onPressed: () => send(LayerAdded(context.l10n.defaultLayerName)),
  );

  AppCommand get layerDelete => AppCommand(
    label: context.l10n.layerDelete,
    icon: Icons.delete_outline,
    onPressed: state.drawing.layers.length > 1
        ? () => send(LayerDeleted(bloc.state.layerIndex))
        : null,
  );

  AppCommand get layerRename => AppCommand(
    label: context.l10n.layerRename,
    icon: Icons.edit_outlined,
    onPressed: () async {
      final s = bloc.state;
      final name = await promptText(
        context,
        title: context.l10n.layerRename,
        initial: s.layer.name,
      );
      if (name != null && name.isNotEmpty) {
        send(LayerRenamed(s.layerIndex, name));
      }
    },
  );

  AppCommand get layerUp => AppCommand(
    label: context.l10n.layerMoveUp,
    icon: Icons.arrow_upward,
    onPressed: state.layerIndex < state.drawing.layers.length - 1
        ? () => send(LayerMoved(bloc.state.layerIndex, 1))
        : null,
  );

  AppCommand get layerDown => AppCommand(
    label: context.l10n.layerMoveDown,
    icon: Icons.arrow_downward,
    onPressed: state.layerIndex > 0
        ? () => send(LayerMoved(bloc.state.layerIndex, -1))
        : null,
  );

  AppCommand get layerVisible => AppCommand(
    label: state.layer.visible
        ? context.l10n.layerHide
        : context.l10n.layerShow,
    icon: Icons.visibility,
    checked: state.layer.visible,
    onPressed: () => send(LayerVisibilityToggled(bloc.state.layerIndex)),
  );
}
