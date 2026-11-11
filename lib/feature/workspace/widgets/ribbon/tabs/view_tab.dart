// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the View tab.
List<Widget> viewTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: c.context.l10n.ribbonZoom,
    children: [
      RibbonButton.large(c.zoomFit, label: c.context.l10n.ribbonFit),
      RibbonStack(
        children: [
          RibbonButton.small(c.zoomIn),
          RibbonButton.small(c.zoomOut),
          RibbonLabel(c.context.l10n.viewZoomLabel(c.zoomLabel)),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonShow,
    children: [
      RibbonStack(
        children: [RibbonButton.small(c.grid), RibbonButton.small(c.snap)],
      ),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonCanvas,
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
    label: c.context.l10n.ribbonAppearance,
    children: [
      RibbonButton.large(c.theme, label: c.context.l10n.ribbonLightDark),
    ],
  ),
];
