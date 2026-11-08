// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'inline_tree_name_editor.dart';

/// Shows a selectable group with an independent collapse control.
class GroupTreeTile extends StatefulWidget {
  const GroupTreeTile({
    super.key,
    required this.name,
    required this.tooltip,
    required this.selected,
    required this.onRename,
    required this.onSelect,
    required this.children,
  });

  final String name;
  final String tooltip;
  final bool selected;
  final ValueChanged<String> onRename;
  final VoidCallback onSelect;
  final List<Widget> children;

  @override
  State<GroupTreeTile> createState() => _GroupTreeTileState();
}

class _GroupTreeTileState extends State<GroupTreeTile> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.only(left: 24, right: 8),
        leading: const Icon(Icons.folder_outlined, size: 18),
        title: InlineTreeNameEditor(
          name: widget.name,
          tooltip: widget.tooltip,
          style: widget.selected
              ? TextStyle(color: Theme.of(context).colorScheme.primary)
              : null,
          onSaved: widget.onRename,
        ),
        trailing: IconButton(
          iconSize: 18,
          visualDensity: VisualDensity.compact,
          icon: Icon(_expanded ? Icons.expand_more : Icons.chevron_right),
          onPressed: () => setState(() => _expanded = !_expanded),
        ),
        selected: widget.selected,
        onTap: widget.onSelect,
      ),
      if (_expanded) ...widget.children,
    ],
  );
}
