// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/drawing/paint_layer.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/models/shapes/shape_kind.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'inline_tree_name_editor.dart';

/// Shows the shapes and picture nested under one layer.
class LayerItemTree extends StatelessWidget {
  const LayerItemTree({
    super.key,
    required this.layer,
    required this.layerIndex,
    required this.state,
  });

  final PaintLayer layer;
  final int layerIndex;
  final EditorState state;

  @override
  Widget build(BuildContext context) {
    final entries = _entries(layer.shapes);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in entries)
          if (entry.groupId == null)
            _shapeTile(context, entry.indices.single, leftPadding: 32)
          else
            _groupTile(context, entry),
        if (layer.image != null) _imageTile(context),
      ],
    );
  }

  List<_TreeEntry> _entries(List<Shape> shapes) {
    final seenGroups = <String>{};
    final entries = <_TreeEntry>[];
    var groupNumber = 0;
    for (var index = shapes.length - 1; index >= 0; index--) {
      final groupId = shapes[index].groupId;
      if (groupId == null) {
        entries.add(_TreeEntry.item([index]));
      } else if (seenGroups.add(groupId)) {
        groupNumber++;
        entries.add(
          _TreeEntry.group(
            groupId,
            shapes[index].groupName ?? 'Group $groupNumber',
            [
              for (var memberIndex = shapes.length - 1;
                  memberIndex >= 0;
                  memberIndex--)
                if (shapes[memberIndex].groupId == groupId) memberIndex,
            ],
          ),
        );
      }
    }
    return entries;
  }

  Widget _groupTile(BuildContext context, _TreeEntry entry) {
    final selected = layerIndex == state.layerIndex &&
        entry.indices.every(state.validSelectedIndices.contains);
    final color = Theme.of(context).colorScheme.primary;
    return ExpansionTile(
      key: PageStorageKey('group-$layerIndex-${entry.groupId}'),
      dense: true,
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.only(left: 24, right: 16),
      childrenPadding: EdgeInsets.zero,
      leading: const Icon(Icons.folder_outlined, size: 18),
      title: InlineTreeNameEditor(
        name: entry.name,
        tooltip: context.l10n.layerEditGroup,
        style: selected ? TextStyle(color: color) : null,
        onSaved: (name) => context.read<EditorBloc>().add(
          GroupRenamed(layerIndex, entry.groupId!, name),
        ),
      ),
      children: [
        for (final index in entry.indices)
          _shapeTile(context, index, leftPadding: 48),
      ],
    );
  }

  Widget _shapeTile(
    BuildContext context,
    int index, {
    required double leftPadding,
  }) {
    final shape = layer.shapes[index];
    final selected = layerIndex == state.layerIndex &&
        state.validSelectedIndices.contains(index);
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.only(left: leftPadding, right: 16),
      leading: Icon(_shapeIcon(shape.kind), size: 16),
      title: InlineTreeNameEditor(
        name: shape.name.isEmpty
            ? _shapeLabel(context, shape.kind)
            : shape.name,
        tooltip: context.l10n.layerEditItem,
        style: Theme.of(context).textTheme.bodySmall,
        allowEmpty: true,
        onSaved: (name) => context.read<EditorBloc>().add(
          ShapeRenamed(name, layer: layerIndex, index: index),
        ),
      ),
      selected: selected,
      onTap: () => context
          .read<EditorBloc>()
          .add(
            ShapeSelectionRequested(
              layerIndex,
              index,
              includeGroup: false,
            ),
          ),
    );
  }

  Widget _imageTile(BuildContext context) => ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.only(left: 32, right: 16),
        leading: const Icon(Icons.image_outlined, size: 16),
        title: Text(
          context.l10n.layerPicture,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        selected: layerIndex == state.layerIndex && state.imageSelected,
        onTap: () => context.read<EditorBloc>().add(const ImageSelected()),
      );

  String _shapeLabel(BuildContext context, ShapeKind kind) => switch (kind) {
        ShapeKind.rect => context.l10n.layerItemRectangle,
        ShapeKind.ellipse => context.l10n.layerItemEllipse,
        ShapeKind.line => context.l10n.layerItemLine,
        ShapeKind.polygon => context.l10n.layerItemPolygon,
        ShapeKind.freehand => context.l10n.layerItemFreehand,
      };

  IconData _shapeIcon(ShapeKind kind) => switch (kind) {
        ShapeKind.rect => Icons.crop_square,
        ShapeKind.ellipse => Icons.circle_outlined,
        ShapeKind.line => Icons.horizontal_rule,
        ShapeKind.polygon => Icons.change_history,
        ShapeKind.freehand => Icons.brush_outlined,
      };
}

class _TreeEntry {
  const _TreeEntry.item(this.indices) : groupId = null, name = '';

  const _TreeEntry.group(this.groupId, this.name, this.indices);

  final String? groupId;
  final String name;
  final List<int> indices;
}
