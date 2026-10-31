// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Home tab.
List<Widget> homeTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'History',
    children: [RibbonButton.large(c.undo), RibbonButton.large(c.redo)],
  ),
  RibbonGroup(
    label: 'Shape',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.duplicate),
          RibbonButton.small(c.delete),
          RibbonButton.small(c.closedPath),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Arrange',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.bringForward),
          RibbonButton.small(c.sendBackward),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Style',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.fillOn),
          RibbonButton.small(c.strokeOn),
        ],
      ),
    ],
  ),
];
