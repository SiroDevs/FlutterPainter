// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../commands/app_command.dart';
import 'app_menu_model.dart';

/// Draws the workspace menus inside Linux and Windows windows.
class WindowMenuBar extends StatelessWidget {
  const WindowMenuBar({super.key, required this.menus});

  final List<AppMenu> menus;

  Widget _item(AppCommand command) {
    final keyText = command.keyText;
    final trailing = keyText == null ? null : Text(keyText);
    if (command.checked != null) {
      return CheckboxMenuButton(
        value: command.checked,
        onChanged: command.onPressed == null
            ? null
            : (_) => command.onPressed!(),
        trailingIcon: trailing,
        child: Text(command.label),
      );
    }
    return MenuItemButton(
      onPressed: command.onPressed,
      leadingIcon: Icon(command.icon, size: 18),
      trailingIcon: trailing,
      child: Text(command.label),
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
      data: theme.copyWith(
        menuButtonTheme: MenuButtonThemeData(style: compact),
      ),
      child: MenuBar(
        style: MenuStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(
            theme.colorScheme.surfaceContainerLow,
          ),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
        children: [
          for (final menu in menus)
            SubmenuButton(
              menuChildren: [
                for (final node in menu.nodes)
                  switch (node) {
                    AppMenuSeparator() => const Divider(height: 1),
                    AppMenuCommand(:final command) => _item(command),
                  },
              ],
              child: MenuAcceleratorLabel('&${menu.label}'),
            ),
        ],
      ),
    );
  }
}
