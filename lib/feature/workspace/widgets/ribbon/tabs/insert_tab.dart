// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../domain/models/editor/tool.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Insert tab.
List<Widget> insertTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'Shapes',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.tool(Tool.rect)),
          RibbonButton.small(c.tool(Tool.ellipse)),
          RibbonButton.small(c.tool(Tool.line)),
        ],
      ),
      RibbonButton.large(c.tool(Tool.paint)),
    ],
  ),
  RibbonGroup(
    label: 'Paths',
    children: [
      RibbonButton.large(c.tool(Tool.polygon), label: 'Polygon'),
      RibbonButton.large(c.tool(Tool.freehand)),
    ],
  ),
  RibbonGroup(
    label: 'Pictures',
    children: [
      RibbonButton.large(c.imageLoad, label: 'Picture'),
      RibbonButton.large(c.imageLoadNewLayer, label: 'Picture on new layer'),
    ],
  ),
  RibbonGroup(label: 'Layers', children: [RibbonButton.large(c.layerAdd)]),
];
