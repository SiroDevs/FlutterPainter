// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/models/shapes/shape_kind.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';

/// Shows selected item details and inline actions for renaming its item/group.
class PropertySelectionInfo extends StatelessWidget {
  const PropertySelectionInfo({
    super.key,
    required this.state,
    required this.shape,
    required this.bloc,
  });

  final EditorState state;
  final Shape? shape;
  final EditorBloc bloc;

  @override
  Widget build(BuildContext context) {
    final count = state.validSelectedIndices.length;
    final groupId = _selectedGroupId();
    final groupShape = groupId == null
        ? null
        : state.layer.shapes[state.validSelectedIndices.first];
    final groupName = groupShape?.groupName ?? context.l10n.layerGroup;
    return SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.propertyTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (count > 1)
            Text(
              context.l10n.shapeSelectionCount(count),
              style: Theme.of(context).textTheme.bodySmall,
            )
          else if (shape == null)
            Text(
              context.l10n.propertyNoSelection,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    shape!.name.isEmpty
                        ? _shapeKindLabel(context, shape!.kind)
                        : shape!.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.propertyRenameShape,
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _renameShape(context, shape!),
                ),
              ],
            ),
            Text(
              _bounds(shape!),
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (groupId != null)
            Row(
              children: [
                const Icon(Icons.folder_outlined, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    groupName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.layerEditGroup,
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _renameGroup(context, groupId, groupName),
                ),
              ],
            ),
          if (count > 0)
            Text(
              context.l10n.shapeRotateHint,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  String? _selectedGroupId() {
    final indices = state.validSelectedIndices;
    if (indices.isEmpty) return null;
    final groupId = state.layer.shapes[indices.first].groupId;
    if (groupId == null) return null;
    return indices.every(
          (index) => state.layer.shapes[index].groupId == groupId,
        )
        ? groupId
        : null;
  }

  Future<void> _renameShape(BuildContext context, Shape selectedShape) async {
    final name = await promptText(
      context,
      title: context.l10n.propertyRenameShape,
      initial: selectedShape.name,
    );
    if (name != null) bloc.add(ShapeRenamed(name));
  }

  Future<void> _renameGroup(
    BuildContext context,
    String groupId,
    String currentName,
  ) async {
    final name = await promptText(
      context,
      title: context.l10n.layerEditGroup,
      initial: currentName,
    );
    if (name == null || name.isEmpty || name == currentName) return;
    bloc.add(GroupRenamed(state.layerIndex, groupId, name));
  }

  String _bounds(Shape shape) {
    final bounds = shape.bounds;
    String format(double value) => value.toStringAsFixed(1);
    return 'x ${format(bounds.left)}  y ${format(bounds.top)}  '
        'w ${format(bounds.width)}  h ${format(bounds.height)}';
  }

  String _shapeKindLabel(BuildContext context, ShapeKind kind) =>
      switch (kind) {
        ShapeKind.rect => context.l10n.layerItemRectangle,
        ShapeKind.ellipse => context.l10n.layerItemEllipse,
        ShapeKind.line => context.l10n.layerItemLine,
        ShapeKind.polygon => context.l10n.layerItemPolygon,
        ShapeKind.freehand => context.l10n.layerItemFreehand,
      };
}
