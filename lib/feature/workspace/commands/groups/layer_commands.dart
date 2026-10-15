// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/logic/exports.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension LayerCommands on WorkspaceCommands {
  AppCommand get layerAdd => AppCommand(
        label: 'New layer',
        icon: Icons.add_box_outlined,
        onPressed: () => send(const LayerAdded()),
      );

  AppCommand get layerDelete => AppCommand(
        label: 'Delete layer',
        icon: Icons.delete_outline,
        onPressed: state.drawing.layers.length > 1
            ? () => send(LayerDeleted(bloc.state.layerIndex))
            : null,
      );

  AppCommand get layerRename => AppCommand(
        label: 'Rename layer…',
        icon: Icons.edit_outlined,
        onPressed: () async {
          final s = bloc.state;
          final name = await promptText(
            context,
            title: 'Rename layer',
            initial: s.layer.name,
          );
          if (name != null && name.isNotEmpty) {
            send(LayerRenamed(s.layerIndex, name));
          }
        },
      );

  AppCommand get layerUp => AppCommand(
        label: 'Move layer up',
        icon: Icons.arrow_upward,
        onPressed: state.layerIndex < state.drawing.layers.length - 1
            ? () => send(LayerMoved(bloc.state.layerIndex, 1))
            : null,
      );

  AppCommand get layerDown => AppCommand(
        label: 'Move layer down',
        icon: Icons.arrow_downward,
        onPressed: state.layerIndex > 0
            ? () => send(LayerMoved(bloc.state.layerIndex, -1))
            : null,
      );

  AppCommand get layerVisible => AppCommand(
        label: 'Show layer',
        icon: Icons.visibility,
        checked: state.layer.visible,
        onPressed: () => send(LayerVisibilityToggled(bloc.state.layerIndex)),
      );
}
