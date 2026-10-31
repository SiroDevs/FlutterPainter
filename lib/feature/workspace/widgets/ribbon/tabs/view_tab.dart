// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the View tab.
List<Widget> viewTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'Zoom',
    children: [
      RibbonButton.large(c.zoomFit, label: 'Fit'),
      RibbonStack(
        children: [
          RibbonButton.small(c.zoomIn),
          RibbonButton.small(c.zoomOut),
          RibbonLabel('Zoom ${c.zoomLabel}'),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Show',
    children: [
      RibbonStack(
        children: [RibbonButton.small(c.grid), RibbonButton.small(c.snap)],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Canvas',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.background),
          RibbonButton.small(c.canvasSize),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Appearance',
    children: [RibbonButton.large(c.theme, label: 'Light / dark')],
  ),
];
