// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../commands/commands_builder.dart';
import '../../commands/workspace_commands.dart';
import 'ribbon_parts.dart';
import 'ribbon_tabs.dart';

/// Which ribbon tab is open and whether the ribbon is collapsed. It lives
/// above the per-project editors so switching projects keeps the same tab.
class RibbonController {
  final ValueNotifier<RibbonTab> tab = ValueNotifier(RibbonTab.home);
  final ValueNotifier<bool> collapsed = ValueNotifier(false);

  void dispose() {
    tab.dispose();
    collapsed.dispose();
  }
}

/// A Word-style ribbon: a row of tabs (File, Home, Insert, ...) and, under the
/// open tab, labelled groups of buttons. Double-click a tab, or use the arrow
/// at the right, to collapse it to just the tabs.
class Ribbon extends StatelessWidget {
  const Ribbon({super.key, required this.controller});

  final RibbonController controller;

  static const double _tabHeight = 36;
  static const double _panelHeight = 100;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      child: ListenableBuilder(
        listenable: Listenable.merge([controller.tab, controller.collapsed]),
        builder: (context, _) => CommandsBuilder(
          detailed: true,
          builder: (context, c) {
            final collapsed = controller.collapsed.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TabRow(controller: controller, commands: c),
                const Divider(height: 1),
                if (!collapsed)
                  SizedBox(
                    height: _panelHeight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: ribbonGroups(controller.tab.value, c),
                      ),
                    ),
                  ),
                if (!collapsed) const Divider(height: 1),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({required this.controller, required this.commands});

  final RibbonController controller;
  final WorkspaceCommands commands;

  @override
  Widget build(BuildContext context) {
    final collapsed = controller.collapsed.value;
    return SizedBox(
      height: Ribbon._tabHeight,
      child: Row(children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 4),
            children: [
              for (final t in RibbonTab.values)
                _TabLabel(
                  title: t.title,
                  selected: t == controller.tab.value && !collapsed,
                  onTap: () {
                    controller.tab.value = t;
                    controller.collapsed.value = false;
                  },
                  onDoubleTap: () =>
                      controller.collapsed.value = !controller.collapsed.value,
                ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 170),
          child: TextButton.icon(
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            onPressed: commands.rename.onPressed,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: Text(
              commands.state.drawing.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        CommandIconButton(commands.undo),
        CommandIconButton(commands.redo),
        const SizedBox(width: 4),
        FilledButton.icon(
          style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
          onPressed: commands.exportDart.onPressed,
          icon: const Icon(Icons.code, size: 18),
          label: const Text('Export'),
        ),
        CommandIconButton(commands.settings),
        IconButton(
          tooltip: collapsed ? 'Expand the ribbon' : 'Collapse the ribbon',
          iconSize: 20,
          visualDensity: VisualDensity.compact,
          icon: Icon(collapsed ? Icons.expand_more : Icons.expand_less),
          onPressed: () => controller.collapsed.value = !collapsed,
        ),
        const SizedBox(width: 4),
      ]),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.onDoubleTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? scheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? scheme.primary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
