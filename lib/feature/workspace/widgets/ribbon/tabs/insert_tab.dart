// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/editor/tool.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Insert tab.
List<Widget> insertTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: c.context.l10n.ribbonShapes,
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.tool(Tool.rect)),
          RibbonButton.small(c.tool(Tool.ellipse)),
        ],
      ),
      RibbonButton.large(c.tool(Tool.paint)),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonPaths,
    children: [
      RibbonButton.large(c.tool(Tool.line)),
      RibbonButton.large(
        c.tool(Tool.polygon),
        label: c.context.l10n.ribbonPolygon,
      ),
      RibbonButton.large(c.tool(Tool.freehand)),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonPictures,
    children: [
      RibbonButton.large(c.imageLoad, label: c.context.l10n.ribbonPicture),
      RibbonButton.large(
        c.imageLoadNewLayer,
        label: c.context.l10n.imageLoadNewLayer,
      ),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonLayersGroup,
    children: [RibbonButton.large(c.layerAdd)],
  ),
];
