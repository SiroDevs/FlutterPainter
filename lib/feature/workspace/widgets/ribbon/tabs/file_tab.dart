// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the File tab.
List<Widget> fileTabGroups(WorkspaceCommands c) => [
  RibbonGroup(
    label: c.context.l10n.ribbonNew,
    children: [
      RibbonButton.large(c.newBlank, label: c.context.l10n.ribbonBlankCanvas),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonOpen,
    children: [RibbonButton.large(c.open, label: c.context.l10n.ribbonOpen)],
  ),
  RibbonGroup(
    label: c.context.l10n.projectImportGroup,
    children: [
      RibbonButton.large(c.importProject, label: c.context.l10n.projectImport),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.fileSave,
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
    label: c.context.l10n.ribbonExport,
    children: [
      RibbonButton.large(c.exportDart, label: c.context.l10n.fileExportDart),
    ],
  ),
  RibbonGroup(
    label: c.context.l10n.ribbonProject,
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
  RibbonGroup(
    label: c.context.l10n.ribbonApp,
    children: [RibbonButton.large(c.settings)],
  ),
];
