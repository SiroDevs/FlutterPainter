// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the File tab.
List<Widget> fileTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'New',
    children: [
      RibbonButton.large(c.newBlank, label: 'Blank canvas'),
    ],
  ),
  RibbonGroup(
    label: 'Open',
    children: [RibbonButton.large(c.open, label: 'Open')],
  ),
  RibbonGroup(
    label: 'Save',
    children: [
      RibbonButton.large(c.save),
      RibbonStack(
        children: [
          RibbonButton.small(c.saveAs),
          RibbonButton.small(c.autoSave),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Export',
    children: [RibbonButton.large(c.exportDart, label: 'Export Dart')],
  ),
  RibbonGroup(
    label: 'Project',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.rename),
          RibbonButton.small(c.canvasSize),
          RibbonButton.small(c.closeProject),
        ],
      ),
    ],
  ),
  RibbonGroup(label: 'App', children: [RibbonButton.large(c.settings)]),
];
