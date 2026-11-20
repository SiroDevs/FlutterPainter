// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/drawing/paint_layer.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'group_tree_tile.dart';
import 'layer_shape_tile.dart';
import 'layer_tree_actions.dart';

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
    final entries = _entries(context, layer.shapes);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in entries)
          if (entry.groupId == null)
            _shapeTile(context, entry.indices.single, grouped: false)
          else
            _groupTile(context, entry),
        if (layer.image != null) _imageTile(context),
      ],
    );
  }

  List<_TreeEntry> _entries(BuildContext context, List<Shape> shapes) {
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
            shapes[index].groupName ??
                context.l10n.layerDefaultGroup(groupNumber),
            [
              for (
                var memberIndex = shapes.length - 1;
                memberIndex >= 0;
                memberIndex--
              )
                if (shapes[memberIndex].groupId == groupId) memberIndex,
            ],
          ),
        );
      }
    }
    return entries;
  }

  Widget _groupTile(BuildContext context, _TreeEntry entry) {
    final visibleIndices = entry.indices
        .where((index) => layer.shapes[index].visible)
        .toList();
    final selected =
        layerIndex == state.layerIndex &&
        visibleIndices.isNotEmpty &&
        visibleIndices.every(state.validSelectedIndices.contains);
    final visible = visibleIndices.length == entry.indices.length;
    return GroupTreeTile(
      key: ValueKey('group-${state.tabId}-$layerIndex-${entry.groupId}'),
      name: entry.name,
      tooltip: context.l10n.layerEditGroup,
      selected: selected,
      visible: visible,
      visibilityTooltip: visible
          ? context.l10n.layerHide
          : context.l10n.layerShow,
      onToggleVisibility: () => context.read<EditorBloc>().add(
        ShapeVisibilityToggled(
          layerIndex,
          entry.indices.first,
          includeGroup: true,
        ),
      ),
      onRename: (name) => context.read<EditorBloc>().add(
        GroupRenamed(layerIndex, entry.groupId!, name),
      ),
      onSelect: () => context.read<EditorBloc>().add(
        ShapeSelectionRequested(
          layerIndex,
          visibleIndices.isEmpty ? entry.indices.first : visibleIndices.first,
          includeGroup: true,
        ),
      ),
      onContextMenu: (position) => LayerTreeActions.showGroup(
        context,
        position,
        layer: layer,
        layerIndex: layerIndex,
        indices: entry.indices,
        groupId: entry.groupId!,
        name: entry.name,
        visible: visible,
      ),
      children: [
        for (final index in entry.indices)
          _shapeTile(context, index, grouped: true),
      ],
    );
  }

  Widget _shapeTile(BuildContext context, int index, {required bool grouped}) =>
      LayerShapeTile(
        layer: layer,
        layerIndex: layerIndex,
        index: index,
        tabId: state.tabId,
        selected:
            layerIndex == state.layerIndex &&
            state.validSelectedIndices.contains(index),
        grouped: grouped,
      );

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
}

class _TreeEntry {
  const _TreeEntry.item(this.indices) : groupId = null, name = '';

  const _TreeEntry.group(this.groupId, this.name, this.indices);

  final String? groupId;
  final String name;
  final List<int> indices;
}
