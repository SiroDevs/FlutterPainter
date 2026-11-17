// Flutter imports:
import 'package:flutter/material.dart';

/// A row of choice chips followed by add, rename and delete buttons. Each
/// button shows only when its callback is given; rename and delete also need
/// at least one item.
class ItemChipRow extends StatelessWidget {
  const ItemChipRow({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.onAdd,
    this.addTooltip,
    this.onRename,
    this.renameTooltip,
    this.onDelete,
    this.deleteTooltip,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final VoidCallback? onAdd;
  final String? addTooltip;
  final VoidCallback? onRename;
  final String? renameTooltip;
  final VoidCallback? onDelete;
  final String? deleteTooltip;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < labels.length; index++)
          ChoiceChip(
            label: Text(labels[index]),
            selected: index == selected,
            onSelected: (_) => onSelected(index),
          ),
        if (onAdd != null) _button(Icons.add, addTooltip, onAdd),
        if (onRename != null && labels.isNotEmpty)
          _button(Icons.edit_outlined, renameTooltip, onRename),
        if (onDelete != null && labels.isNotEmpty)
          _button(Icons.delete_outline, deleteTooltip, onDelete),
      ],
    );
  }

  Widget _button(IconData icon, String? tooltip, VoidCallback? onPressed) =>
      IconButton(
        tooltip: tooltip,
        iconSize: 18,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon),
        onPressed: onPressed,
      );
}
