// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/editor_ops.dart';

/// Actions that apply to the current shape selection.
class ShapeActions extends StatelessWidget {
  const ShapeActions({super.key, required this.state});

  final EditorState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    final selectionCount = state.validSelectedIndices.length;
    final selectedShapes = state.selectedShapes;
    final groups = selectedShapes.map((shape) => shape.groupId).toSet();
    final canGroup =
        selectedShapes.length > 1 && (groups.length > 1 || groups.single == null);
    final grouped = selectedShapes.any((shape) => shape.groupId != null);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _action(
          Icons.copy,
          context.l10n.shapeDuplicate,
          () => bloc.add(const ShapeDuplicated()),
        ),
        _action(
          Icons.delete_outline,
          context.l10n.shapeDelete,
          () => bloc.add(const ShapeDeleted()),
        ),
        if (selectionCount == 1) ...[
          _action(
            Icons.flip_to_front,
            context.l10n.shapeForward,
            () => bloc.add(const ShapeReordered(1)),
          ),
          _action(
            Icons.flip_to_back,
            context.l10n.shapeBack,
            () => bloc.add(const ShapeReordered(-1)),
          ),
          _moveToLayer(context, bloc),
        ],
        if (canGroup)
          _action(
            Icons.group_work_outlined,
            context.l10n.shapeGroup,
            () => bloc.add(const ShapesGrouped()),
          ),
        if (grouped)
          _action(
            Icons.workspaces_outline,
            context.l10n.shapeUngroup,
            () => bloc.add(const ShapesUngrouped()),
          ),
      ],
    );
  }

  Widget _moveToLayer(BuildContext context, EditorBloc bloc) =>
      PopupMenuButton<int>(
        tooltip: context.l10n.shapeMoveToLayer,
        onSelected: (index) => bloc.add(ShapeMovedToLayer(index)),
        itemBuilder: (_) => [
          for (var index = state.drawing.layers.length - 1; index >= 0; index--)
            PopupMenuItem(
              value: index,
              child: Text(state.drawing.layers[index].name),
            ),
        ],
        child: Chip(
          avatar: Icon(Icons.layers, size: 16),
          label: Text(context.l10n.shapeToLayer),
        ),
      );

  Widget _action(IconData icon, String label, VoidCallback onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
      );
}
