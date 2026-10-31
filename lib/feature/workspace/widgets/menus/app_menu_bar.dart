// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/constants/app_constants.dart';
import '../../../editor/widgets/toolbar/tool_info.dart';
import '../../commands/app_command.dart';
import '../../commands/commands_builder.dart';
import '../../commands/workspace_commands.dart';

sealed class _Node {
  const _Node();
}

class _Item extends _Node {
  const _Item(this.command);

  final AppCommand command;
}

class _Separator extends _Node {
  const _Separator();
}

class _Menu {
  const _Menu(this.label, this.nodes);

  final String label;
  final List<_Node> nodes;
}

const _sep = _Separator();

List<_Menu> _menus(WorkspaceCommands c, {required bool mac}) => [
      _Menu('File', [
        _Item(c.newBlank),
        _sep,
        _Item(c.open),
        _sep,
        _Item(c.save),
        _Item(c.saveAs),
        _Item(c.autoSave),
        _sep,
        _Item(c.exportDart),
        _sep,
        _Item(c.rename),
        _Item(c.canvasSize),
        _sep,
        _Item(c.closeProject),
        if (!mac) ...[_sep, _Item(c.settings), _sep, _Item(c.exitApp)],
      ]),
      _Menu('Edit', [
        _Item(c.undo),
        _Item(c.redo),
        _sep,
        _Item(c.duplicate),
        _Item(c.delete),
        _sep,
        _Item(c.bringForward),
        _Item(c.sendBackward),
        _Item(c.closedPath),
        _sep,
        _Item(c.fillOn),
        _Item(c.strokeOn),
      ]),
      _Menu('Layer', [
        _Item(c.layerAdd),
        _Item(c.layerDelete),
        _Item(c.layerRename),
        _sep,
        _Item(c.layerUp),
        _Item(c.layerDown),
        _Item(c.layerVisible),
        _sep,
        _Item(c.imageLoad),
        _Item(c.imageLoadNewLayer),
        _Item(c.imageSelect),
        _Item(c.imageTool),
        _Item(c.imageFit),
        _Item(c.imageVisible),
        _Item(c.imageRemove),
      ]),
      _Menu('View', [
        _Item(c.zoomIn),
        _Item(c.zoomOut),
        _Item(c.zoomFit),
        _sep,
        _Item(c.grid),
        _Item(c.snap),
        _Item(c.background),
        _sep,
        _Item(c.theme),
      ]),
      _Menu('Tools', [
        for (var g = 0; g < kToolGroups.length; g++) ...[
          if (g > 0) _sep,
          for (final t in kToolGroups[g]) _Item(c.tool(t)),
        ],
      ]),
      if (!mac) _Menu('Help', [_Item(c.about)]),
    ];

/// The application's menu bar.
///
/// - macOS: the real menu bar at the top of the screen (`PlatformMenuBar`),
///   with the standard application and Window menus.
/// - Windows and Linux: Flutter has no native menu bar there, so the same menus
///   are drawn as a menu bar at the top of the window, which is where those
///   systems put them. Alt+letter opens a menu.
///
/// It must sit under the active tab's `EditorBloc` provider.
class AppMenuBar extends StatelessWidget {
  const AppMenuBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // The native menu is always live, even while a dialog or the code editor
    // is on top of the workspace. Reading the route here rebuilds the menu when
    // that changes, so its items can be greyed out then.
    final active = ModalRoute.of(context)?.isCurrent ?? true;
    return CommandsBuilder(
      builder: (context, c) {
        if (isMacOS) {
          return PlatformMenuBar(menus: _macMenus(c, active), child: child);
        }
        return Column(children: [
          _WindowMenuBar(menus: _menus(c, mac: false)),
          Expanded(child: child),
        ]);
      },
    );
  }
}

// ---- macOS: native menus ------------------------------------------------------

List<PlatformMenuItem> _macMenus(WorkspaceCommands c, bool active) {
  return [
    PlatformMenu(label: AppConstants.appTitle, menus: [
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
      ]),
      PlatformMenuItemGroup(members: [
        PlatformMenuItem(
          label: c.settings.label,
          shortcut: c.settings.shortcut,
          onSelected: active ? c.settings.onPressed : null,
        ),
      ]),
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.servicesSubmenu,
        ),
      ]),
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.hideOtherApplications,
        ),
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.showAllApplications,
        ),
      ]),
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
      ]),
    ]),
    for (final m in _menus(c, mac: true))
      PlatformMenu(label: m.label, menus: _macItems(m.nodes, c.context, active)),
    PlatformMenu(label: 'Window', menus: [
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.minimizeWindow,
        ),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.toggleFullScreen,
        ),
      ]),
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.arrangeWindowsInFront,
        ),
      ]),
    ]),
  ];
}

/// Items between separators become groups, which the system draws with a line
/// between them.
List<PlatformMenuItem> _macItems(
  List<_Node> nodes,
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
      case _Separator():
        flush();
      case _Item(:final command):
        // The native menu has no check marks in Flutter, so toggles that are
        // on get one in front of their name. Single-key shortcuts are not
        // registered (they would steal the letter from text fields), so they
        // are shown after the name instead.
        final check = (command.checked ?? false) ? '✓ ' : '';
        final hint = command.shortcut == null && command.keys != null
            ? '   ${command.keys}'
            : '';
        current.add(
          PlatformMenuItem(
            label: '$check${command.label}$hint',
            shortcut: command.shortcut,
            // The native menu stays live while a dialog is open; ignore it
            // then, so a key like Cmd+W cannot start a second close prompt.
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

// ---- Windows and Linux: in-window menu bar -----------------------------------

class _WindowMenuBar extends StatelessWidget {
  const _WindowMenuBar({required this.menus});

  final List<_Menu> menus;

  /// Shortcuts are only shown here, not registered: Flutter would register
  /// them for the whole app, so they would also fire behind an open dialog.
  /// The workspace already handles the keys while it has focus.
  Widget _item(AppCommand c) {
    final k = c.keyText;
    final trailing = k == null ? null : Text(k);
    if (c.checked != null) {
      return CheckboxMenuButton(
        value: c.checked,
        onChanged: c.onPressed == null ? null : (_) => c.onPressed!(),
        trailingIcon: trailing,
        child: Text(c.label),
      );
    }
    return MenuItemButton(
      onPressed: c.onPressed,
      leadingIcon: Icon(c.icon, size: 18),
      trailingIcon: trailing,
      child: Text(c.label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = ButtonStyle(
      visualDensity: VisualDensity.compact,
      minimumSize: const WidgetStatePropertyAll(Size(0, 30)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 10),
      ),
    );
    return Theme(
      data: theme.copyWith(menuButtonTheme: MenuButtonThemeData(style: compact)),
      child: MenuBar(
        style: MenuStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor:
              WidgetStatePropertyAll(theme.colorScheme.surfaceContainerLow),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
        children: [
          for (final m in menus)
            SubmenuButton(
              menuChildren: [
                for (final node in m.nodes)
                  switch (node) {
                    _Separator() => const Divider(height: 1),
                    _Item(:final command) => _item(command),
                  },
              ],
              child: MenuAcceleratorLabel('&${m.label}'),
            ),
        ],
      ),
    );
  }
}
