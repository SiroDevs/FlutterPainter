import 'package:flutter/material.dart';

enum TreeContextAction {
  copy,
  paste,
  duplicate,
  rename,
  delete,
  visibility,
  moveUp,
  moveDown,
}

/// Opens a localized menu at the pointer position for a layer-tree row.
Future<TreeContextAction?> showTreeContextMenu(
  BuildContext context,
  Offset position,
  List<(TreeContextAction, String)> actions,
) {
  final size = MediaQuery.sizeOf(context);
  return showMenu<TreeContextAction>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      size.width - position.dx,
      size.height - position.dy,
    ),
    items: [
      for (final (action, label) in actions)
        PopupMenuItem(value: action, child: Text(label)),
    ],
  );
}
