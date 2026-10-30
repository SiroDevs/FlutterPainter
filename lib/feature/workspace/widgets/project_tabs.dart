// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import '../cubit/workspace_cubit.dart';
import '../flows/tab_flows.dart';

/// One tab per open project: its name, an unsaved-changes dot, and a close
/// button. At the end sit a "New Project" button and an "Inline Code" toggle
/// that shows or hides the inline code view.
class ProjectTabs extends StatelessWidget {
  const ProjectTabs({super.key, required this.inlineCode});

  final ValueNotifier<bool> inlineCode;

  @override
  Widget build(BuildContext context) {
    final ws = context.read<WorkspaceCubit>();
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) => Row(children: [
        ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var i = 0; i < state.tabs.length; i++)
              _Tab(
                info: state.tabs[i],
                selected: i == state.active,
                onTap: () => ws.activate(i),
                onClose: () => closeTab(context, ws, ws.editors[i]),
              ),
          ],
        ).expanded(),
        Tooltip(
          message: context.l10n.newProjectTooltip,
          child: TextButton.icon(
            onPressed: ws.addBlank,
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.newProject),
          ),
        ),
        _InlineCodeToggle(open: inlineCode),
      ]).height(38),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.info,
    required this.selected,
    required this.onTap,
    required this.onClose,
  });

  final TabInfo info;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: info.path ?? 'Not saved yet',
      child: InkWell(
        onTap: onTap,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(
            info.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: selected ? FontWeight.w600 : null),
          ).flexible(),
          if (info.dirty) const Icon(Icons.circle, size: 8).padding(left: 6),
          IconButton(
            tooltip: 'Close (Ctrl+W)',
            iconSize: 16,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ])
            .padding(left: 12, right: 4)
            .decorated(
              color: selected ? scheme.surfaceContainerHighest : null,
              border: Border(
                bottom: BorderSide(
                  color: selected ? scheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            )
            .constrained(minWidth: 120, maxWidth: 240),
      ),
    );
  }
}

class _InlineCodeToggle extends StatelessWidget {
  const _InlineCodeToggle({required this.open});

  final ValueNotifier<bool> open;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<bool>(
      valueListenable: open,
      builder: (context, isOpen, _) => Tooltip(
        message: context.l10n.inlineCodeTooltip,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: isOpen ? scheme.primaryContainer : null,
            foregroundColor: isOpen ? scheme.onPrimaryContainer : null,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: () => open.value = !isOpen,
          icon: const Icon(Icons.code, size: 18),
          label: Text(context.l10n.inlineCode),
        ),
      ),
    );
  }
}
