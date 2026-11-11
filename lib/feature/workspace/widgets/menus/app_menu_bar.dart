import 'package:flutter/material.dart';

import '../../../../common/constants/app_constants.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../commands/app_command.dart';
import '../../commands/commands_builder.dart';
import '../../commands/workspace_commands.dart';
import 'app_menu_model.dart';
import 'window_menu_bar.dart';

/// Places native menus on macOS and in-window menus on Linux and Windows.
class AppMenuBar extends StatelessWidget {
  const AppMenuBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final active = ModalRoute.of(context)?.isCurrent ?? true;
    return CommandsBuilder(
      builder: (context, commands) {
        if (isMacOS) {
          return PlatformMenuBar(
            menus: _macMenus(commands, active),
            child: child,
          );
        }
        return Column(
          children: [
            WindowMenuBar(menus: buildAppMenus(commands, mac: false)),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

List<PlatformMenuItem> _macMenus(WorkspaceCommands commands, bool active) => [
  PlatformMenu(
    label: AppConstants.appTitle,
    menus: [
      PlatformMenuItemGroup(
        members: [
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
        ],
      ),
      PlatformMenuItemGroup(
        members: [
          PlatformMenuItem(
            label: commands.settings.label,
            shortcut: commands.settings.shortcut,
            onSelected: active ? commands.settings.onPressed : null,
          ),
        ],
      ),
      PlatformMenuItemGroup(
        members: [
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.servicesSubmenu,
          ),
        ],
      ),
      PlatformMenuItemGroup(
        members: [
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.hideOtherApplications,
          ),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.showAllApplications,
          ),
        ],
      ),
      PlatformMenuItemGroup(
        members: [
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
        ],
      ),
    ],
  ),
  for (final menu in buildAppMenus(commands, mac: true))
    PlatformMenu(
      label: menu.label,
      menus: _macItems(menu.nodes, commands.context, active),
    ),
  PlatformMenu(
    label: commands.context.l10n.menuWindow,
    menus: [
      PlatformMenuItemGroup(
        members: [
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.minimizeWindow,
          ),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.zoomWindow,
          ),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.toggleFullScreen,
          ),
        ],
      ),
      PlatformMenuItemGroup(
        members: [
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.arrangeWindowsInFront,
          ),
        ],
      ),
    ],
  ),
];

List<PlatformMenuItem> _macItems(
  List<AppMenuNode> nodes,
  BuildContext context,
  bool active,
) {
  final groups = <PlatformMenuItem>[];
  var current = <PlatformMenuItem>[];
  void flush() {
    if (current.isEmpty) return;
    groups.add(PlatformMenuItemGroup(members: current));
    current = <PlatformMenuItem>[];
  }

  for (final node in nodes) {
    switch (node) {
      case AppMenuSeparator():
        flush();
      case AppMenuCommand(:final command):
        final check = (command.checked ?? false) ? '✓ ' : '';
        final hint = command.shortcut == null && command.keys != null
            ? '   ${command.keys}'
            : '';
        current.add(
          PlatformMenuItem(
            label: '$check${command.label}$hint',
            shortcut: command.shortcut,
            onSelected: !active || command.onPressed == null
                ? null
                : () {
                    if (ModalRoute.of(context)?.isCurrent ?? true) {
                      command.onPressed!();
                    }
                  },
          ),
        );
    }
  }
  flush();
  return groups;
}
