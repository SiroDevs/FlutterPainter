// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Home tab.
List<Widget> homeTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: c.context.l10n.ribbonHistory,
    children: [RibbonButton.large(c.undo), RibbonButton.large(c.redo)],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonStyle,
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
