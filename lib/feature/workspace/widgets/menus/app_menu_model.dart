// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../../editor/widgets/toolbar/tools/exports.dart';
import '../../commands/app_command.dart';
import '../../commands/workspace_commands.dart';

sealed class AppMenuNode {
  const AppMenuNode();
}

class AppMenuCommand extends AppMenuNode {
  const AppMenuCommand(this.command);

  final AppCommand command;
}

class AppMenuSeparator extends AppMenuNode {
  const AppMenuSeparator();
}

class AppMenu {
  const AppMenu(this.label, this.nodes);

  final String label;
  final List<AppMenuNode> nodes;
}

const _separator = AppMenuSeparator();

/// Builds the shared menu contents for native macOS and desktop menu bars.
List<AppMenu> buildAppMenus(
  WorkspaceCommands commands, {
  required bool mac,
}) => [
  AppMenu(commands.context.l10n.menuFile, [
    AppMenuCommand(commands.newBlank),
    _separator,
    AppMenuCommand(commands.open),
    _separator,
    AppMenuCommand(commands.save),
    AppMenuCommand(commands.saveAs),
    AppMenuCommand(commands.autoSave),
    _separator,
    AppMenuCommand(commands.exportDart),
    _separator,
    AppMenuCommand(commands.rename),
    AppMenuCommand(commands.canvasSize),
    _separator,
    AppMenuCommand(commands.closeProject),
    if (!mac) ...[
      _separator,
      AppMenuCommand(commands.settings),
      _separator,
      AppMenuCommand(commands.exitApp),
    ],
  ]),
  AppMenu(commands.context.l10n.menuEdit, [
    AppMenuCommand(commands.undo),
    AppMenuCommand(commands.redo),
    _separator,
    AppMenuCommand(commands.duplicate),
    AppMenuCommand(commands.delete),
    _separator,
    AppMenuCommand(commands.bringForward),
    AppMenuCommand(commands.sendBackward),
    AppMenuCommand(commands.bringToFront),
    AppMenuCommand(commands.sendToBack),
    AppMenuCommand(commands.closedPath),
    _separator,
    AppMenuCommand(commands.fillOn),
    AppMenuCommand(commands.strokeOn),
  ]),
  AppMenu(commands.context.l10n.menuLayer, [
    AppMenuCommand(commands.layerAdd),
    AppMenuCommand(commands.layerDelete),
    AppMenuCommand(commands.layerRename),
    _separator,
    AppMenuCommand(commands.layerUp),
    AppMenuCommand(commands.layerDown),
    AppMenuCommand(commands.layerVisible),
    _separator,
    AppMenuCommand(commands.layerMake3d),
    AppMenuCommand(commands.layerRemove3d),
    _separator,
    AppMenuCommand(commands.imageLoad),
    AppMenuCommand(commands.imageLoadNewLayer),
    AppMenuCommand(commands.imageSelect),
    AppMenuCommand(commands.imageTool),
    AppMenuCommand(commands.imageFit),
    AppMenuCommand(commands.imageVisible),
    AppMenuCommand(commands.imageRemove),
  ]),
  AppMenu(commands.context.l10n.menuView, [
    AppMenuCommand(commands.zoomIn),
    AppMenuCommand(commands.zoomOut),
    AppMenuCommand(commands.zoomFit),
    _separator,
    AppMenuCommand(commands.grid),
    AppMenuCommand(commands.snap),
    AppMenuCommand(commands.background),
    _separator,
    AppMenuCommand(commands.theme),
  ]),
  AppMenu(commands.context.l10n.menuTools, [
    for (var groupIndex = 0; groupIndex < kToolGroups.length; groupIndex++) ...[
      if (groupIndex > 0) _separator,
      for (final tool in kToolGroups[groupIndex])
        AppMenuCommand(commands.tool(tool)),
    ],
  ]),
  if (!mac)
    AppMenu(commands.context.l10n.menuHelp, [AppMenuCommand(commands.about)]),
];
