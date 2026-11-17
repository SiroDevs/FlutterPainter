// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Layer tab.
List<Widget> layerTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: c.context.l10n.ribbonLayers,
    children: [
      RibbonButton.large(c.layerAdd),
      RibbonButton.small(c.copyLayer),
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
    label: c.context.l10n.ribbon3d,
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.layerMake3d),
          RibbonButton.small(c.layerRemove3d),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonOrder,
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
