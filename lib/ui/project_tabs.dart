// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../workspace/workspace.dart';

/// One tab per open project: its name, an unsaved-changes dot, and a close
/// button. A "+" at the end starts a new blank project.
class ProjectTabs extends StatelessWidget {
  const ProjectTabs({
    super.key,
    required this.workspace,
    required this.onClose,
    required this.onNew,
  });

  final Workspace workspace;
  final void Function(EditorController) onClose;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    // Rebuild on workspace changes and on edits in any tab (names, dirty dot).
    return ListenableBuilder(
      listenable: Listenable.merge([workspace, ...workspace.tabs]),
      builder: (context, _) => SizedBox(
        height: 38,
        child: Row(children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < workspace.tabs.length; i++)
                  _Tab(
                    controller: workspace.tabs[i],
                    selected: i == workspace.active,
                    onTap: () => workspace.activate(i),
                    onClose: () => onClose(workspace.tabs[i]),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'New project (Ctrl+N)',
            iconSize: 20,
            icon: const Icon(Icons.add),
            onPressed: onNew,
          ),
        ]),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.controller,
    required this.selected,
    required this.onTap,
    required this.onClose,
  });

  final EditorController controller;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = controller;
    return Tooltip(
      message: c.filePath ?? 'Not saved yet',
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 120, maxWidth: 240),
          padding: const EdgeInsets.only(left: 12, right: 4),
          decoration: BoxDecoration(
            color: selected ? scheme.surfaceContainerHighest : null,
            border: Border(
              bottom: BorderSide(
                color: selected ? scheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Flexible(
              child: Text(
                c.drawing.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: selected ? FontWeight.w600 : null),
              ),
            ),
            if (c.dirty)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.circle, size: 8),
              ),
            IconButton(
              tooltip: 'Close (Ctrl+W)',
              iconSize: 16,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
          ]),
        ),
      ),
    );
  }
}
