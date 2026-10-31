// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Layer tab.
List<Widget> layerTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'Layers',
    children: [
      RibbonButton.large(c.layerAdd),
      RibbonStack(
        children: [
          RibbonButton.small(c.layerDelete),
          RibbonButton.small(c.layerRename),
          RibbonButton.small(c.layerVisible),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Order',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.layerUp),
          RibbonButton.small(c.layerDown),
        ],
      ),
    ],
  ),
];
