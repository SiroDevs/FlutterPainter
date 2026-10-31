// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../domain/models/tool.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Insert tab.
List<Widget> insertTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'Shapes',
    children: [
      RibbonButton.large(c.tool(Tool.rect)),
      RibbonButton.large(c.tool(Tool.ellipse)),
      RibbonButton.large(c.tool(Tool.line)),
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
