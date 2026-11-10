// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../editor/bloc/editor_bloc.dart';
import '../../../../editor/logic/exports.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

/// Selection, transform and group actions for shapes.
List<Widget> arrangeTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: c.context.l10n.projectTransferGroup,
    children: [
      RibbonButton.small(c.copySelection),
      RibbonButton.small(c.copyGroup),
      RibbonButton.small(c.pasteTransfer),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.shapeTransformGroup,
    children: [
      RibbonButton.small(c.flipHorizontal),
      RibbonButton.small(c.flipVertical),
      RibbonButton.small(c.scaleDown),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.shapeSelectionGroup,
    children: [
      RibbonButton.small(c.duplicate),
      RibbonButton.small(c.delete),
      _MoveToLayerButton(commands: c),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.shapeGroup,
    children: [
      RibbonButton.small(c.group),
      RibbonButton.small(c.ungroup),
      RibbonButton.small(c.bringForward),
      RibbonButton.small(c.sendBackward),
      RibbonButton.small(c.closedPath),
    ],
  ),
];

class _MoveToLayerButton extends StatelessWidget {
  const _MoveToLayerButton({required this.commands});

  final WorkspaceCommands commands;

  @override
  Widget build(BuildContext context) => PopupMenuButton<int>(
    tooltip: context.l10n.shapeMoveToLayer,
    enabled: commands.state.validSelectedIndices.length == 1,
    onSelected: (index) => commands.send(ShapeMovedToLayer(index)),
    itemBuilder: (context) => [
      for (
        var index = commands.state.drawing.layers.length - 1;
        index >= 0;
        index--
      )
        if (index != commands.state.layerIndex)
          PopupMenuItem(
            value: index,
            child: Text(commands.state.drawing.layers[index].name),
          ),
    ],
    child: SizedBox(
      height: 28,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.layers_outlined, size: 16),
            const SizedBox(width: 5),
            Text(
              context.l10n.shapeToLayer,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
