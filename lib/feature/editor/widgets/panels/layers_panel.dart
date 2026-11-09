// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/drawing/paint_layer.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'layer_item_tree.dart';

/// Layer list, top layer first. The active layer receives new shapes.
class LayersPanel extends StatelessWidget {
  const LayersPanel({super.key});

  Future<void> _rename(BuildContext context) async {
    final bloc = context.read<EditorBloc>();
    final state = bloc.state;
    final name = await promptText(
      context,
      title: context.l10n.layerRename,
      initial: state.layer.name,
    );
    if (name != null && name.isNotEmpty) {
      bloc.add(LayerRenamed(state.layerIndex, name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) =>
          a.layerIndex != b.layerIndex ||
          a.selected != b.selected ||
          a.selectedIndices != b.selectedIndices ||
          a.drawing.layers != b.drawing.layers,
      builder: (context, state) {
        final layers = state.drawing.layers;
        final active = state.layerIndex;
        final storageKeys = _storageKeys(state.tabId, layers);
        final rowByKey = <Key, int>{
          for (var row = 0; row < layers.length; row++)
            PageStorageKey<String>(storageKeys[layers.length - 1 - row]): row,
        };
        return Column(
          children: [
            Row(
              children: [
                Text(
                  context.l10n.layersTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                _btn(
                  Icons.add,
                  context.l10n.layerAdd,
                  () => bloc.add(const LayerAdded()),
                ),
                _btn(
                  Icons.edit_outlined,
                  context.l10n.layerRename,
                  () => _rename(context),
                ),
                _btn(
                  Icons.arrow_upward,
                  context.l10n.layerMoveUp,
                  () => bloc.add(LayerMoved(active, 1)),
                  enabled: active < layers.length - 1,
                ),
                _btn(
                  Icons.arrow_downward,
                  context.l10n.layerMoveDown,
                  () => bloc.add(LayerMoved(active, -1)),
                  enabled: active > 0,
                ),
                _btn(
                  Icons.delete_outline,
                  context.l10n.layerDelete,
                  () => bloc.add(LayerDeleted(active)),
                  enabled: layers.length > 1,
                ),
              ],
            ).padding(left: 12),
            ListView.builder(
              key: PageStorageKey<String>('layer-list-${state.tabId}'),
              itemCount: layers.length,
              findChildIndexCallback: (key) => rowByKey[key],
              itemBuilder: (context, row) {
                final index = layers.length - 1 - row;
                final layer = layers[index];
                final layerIsActive = index == active;
                final activeTileColor = layerIsActive
                    ? Theme.of(context).colorScheme.primaryContainer
                          .withAlpha(90)
                    : null;
                return ExpansionTile(
                  key: PageStorageKey<String>(storageKeys[index]),
                  initiallyExpanded: layerIsActive,
                  dense: true,
                  tilePadding: const EdgeInsets.only(left: 8, right: 16),
                  backgroundColor: activeTileColor,
                  collapsedBackgroundColor: activeTileColor,
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
                  title: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (index != bloc.state.layerIndex) {
                        bloc.add(LayerActivated(index));
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            layer.name,
                            style: TextStyle(
                              color: layerIsActive
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
                  children: [
                    LayerItemTree(
                      layer: layer,
                      layerIndex: index,
                      state: state,
                    ),
                  ],
                );
              },
            ).expanded(),
          ],
        );
      },
    );
  }

  List<String> _storageKeys(String tabId, List<PaintLayer> layers) {
    final occurrences = <String, int>{};
    final keys = <String>[];
    for (final layer in layers) {
      final occurrence = occurrences.update(
        layer.name,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      keys.add('$tabId-layer-${layer.name}-$occurrence');
    }
    return keys;
  }

  Widget _btn(
    IconData icon,
    String tip,
    VoidCallback onPressed, {
    bool enabled = true,
  }) => IconButton(
    tooltip: tip,
    iconSize: 18,
    visualDensity: VisualDensity.compact,
    icon: Icon(icon),
    onPressed: enabled ? onPressed : null,
  );
}
