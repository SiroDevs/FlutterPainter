// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../../../core/utils/l10n_ext.dart';
import '../../../../../../domain/models/drawing/paint_layer.dart';
import '../../../../bloc/editor_bloc.dart';
import '../tree/exports.dart';
import 'exports.dart';


/// Lists layers top first and lets the active layer receive new shapes.
class LayersPanel extends StatelessWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (before, after) =>
          before.layerIndex != after.layerIndex ||
          before.selected != after.selected ||
          before.selectedIndices != after.selectedIndices ||
          before.drawing.layers != after.drawing.layers,
      builder: (context, state) {
        final layers = state.drawing.layers;
        final active = state.layerIndex;
        final storageKeys = _storageKeys(state.tabId, layers);
        return Column(
          children: [
            LayersPanelHeader(bloc: bloc, state: state),
            ReorderableListView.builder(
              key: PageStorageKey<String>('layer-list-${state.tabId}'),
              itemCount: layers.length,
              buildDefaultDragHandles: false,
              onReorderItem: (oldRow, newRow) {
                final from = layers.length - 1 - oldRow;
                final to = layers.length - 1 - newRow;
                bloc.add(LayerReordered(from, to));
              },
              itemBuilder: (context, row) {
                final index = layers.length - 1 - row;
                final layer = layers[index];
                final isActive = index == active;
                final activeColor = isActive
                    ? Theme.of(context).colorScheme.primaryContainer
                          .withAlpha(90)
                    : null;
                return GestureDetector(
                  key: ValueKey<String>('layer-row-${storageKeys[index]}'),
                  onSecondaryTapUp: (details) => LayerTreeActions.showLayer(
                    context,
                    details.globalPosition,
                    layer: layer,
                    layerIndex: index,
                    layerCount: layers.length,
                  ),
                  child: ExpansionTile(
                    key: PageStorageKey<String>(storageKeys[index]),
                    initiallyExpanded: isActive,
                    dense: true,
                    tilePadding: const EdgeInsets.only(left: 8, right: 16),
                    backgroundColor: activeColor,
                    collapsedBackgroundColor: activeColor,
                    onExpansionChanged: (expanded) {
                      if (expanded && index != bloc.state.layerIndex) {
                        bloc.add(LayerActivated(index));
                      }
                    },
                    leading: IconButton(
                      tooltip: layer.visible
                          ? context.l10n.layerHide
                          : context.l10n.layerShow,
                      icon: Icon(
                        layer.visible ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                      ),
                      onPressed: () => bloc.add(LayerVisibilityToggled(index)),
                    ),
                    title: _layerTitle(
                      context,
                      bloc,
                      layer,
                      index,
                      row,
                      isActive,
                    ),
                    children: [
                      LayerItemTree(
                        layer: layer,
                        layerIndex: index,
                        state: state,
                      ),
                    ],
                  ),
                );
              },
            ).expanded(),
          ],
        );
      },
    );
  }

  Widget _layerTitle(
    BuildContext context,
    EditorBloc bloc,
    PaintLayer layer,
    int index,
    int row,
    bool isActive,
  ) => Row(
    children: [
      ReorderableDragStartListener(
        index: row,
        child: Tooltip(
          message: context.l10n.layerDragReorder,
          child: const Icon(Icons.drag_handle, size: 18),
        ),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (index != bloc.state.layerIndex) bloc.add(LayerActivated(index));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  layer.name,
                  style: TextStyle(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (layer.image != null)
                      const Icon(
                        Icons.image_outlined,
                        size: 14,
                      ).padding(right: 6),
                    Text(
                      '${layer.shapes.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  List<String> _storageKeys(String tabId, List<PaintLayer> layers) {
    final occurrences = <String, int>{};
    return [
      for (final layer in layers)
        '$tabId-layer-${layer.name}-${occurrences.update(layer.name, (count) => count + 1, ifAbsent: () => 1)}',
    ];
  }
}
