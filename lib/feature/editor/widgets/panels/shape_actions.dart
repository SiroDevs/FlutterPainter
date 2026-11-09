// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';

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
        selectedShapes.length > 1 &&
        (groups.length > 1 || groups.single == null);
    final grouped = selectedShapes.any((shape) => shape.groupId != null);
    final actions = <Widget Function(double width)>[
      (width) => _action(
        Icons.copy,
        context.l10n.shapeDuplicate,
        () => bloc.add(const ShapeDuplicated()),
        width,
      ),
      (width) => _action(
        Icons.delete_outline,
        context.l10n.shapeDelete,
        () => bloc.add(const ShapeDeleted()),
        width,
      ),
      (width) => _action(
        Icons.zoom_out_map,
        context.l10n.shapeScaleDown,
        () => bloc.add(const SelectionScaled(0.9)),
        width,
      ),
      if (selectionCount == 1) ...[
        (width) => _action(
          Icons.flip_to_front,
          context.l10n.shapeForward,
          () => bloc.add(const ShapeReordered(1)),
          width,
        ),
        (width) => _action(
          Icons.flip_to_back,
          context.l10n.shapeBack,
          () => bloc.add(const ShapeReordered(-1)),
          width,
        ),
        (width) => _moveToLayer(context, bloc, width),
      ],
      if (canGroup)
        (width) => _action(
          Icons.group_work_outlined,
          context.l10n.shapeGroup,
          () => bloc.add(const ShapesGrouped()),
          width,
        ),
      if (grouped)
        (width) => _action(
          Icons.workspaces_outline,
          context.l10n.shapeUngroup,
          () => bloc.add(const ShapesUngrouped()),
          width,
        ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth >= 280 ? 2 : 1;
        final buttonWidth =
            (constraints.maxWidth - (columnCount - 1) * 8) / columnCount;
        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            mainAxisSpacing: 4,
            crossAxisSpacing: 8,
            childAspectRatio: buttonWidth / 36,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) => actions[index](buttonWidth),
        );
      },
    );
  }

  Widget _moveToLayer(BuildContext context, EditorBloc bloc, double width) =>
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
        child: SizedBox(
          width: width,
          height: 36,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.layers, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.l10n.shapeToLayer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _action(
    IconData icon,
    String label,
    VoidCallback onPressed,
    double width,
  ) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      fixedSize: Size(width, 36),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    ),
    onPressed: onPressed,
    icon: Icon(icon, size: 16),
    label: SizedBox(
      width: width - 44,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    ),
  );
}
