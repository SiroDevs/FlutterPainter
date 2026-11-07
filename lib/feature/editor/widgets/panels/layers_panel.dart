// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/editor_ops.dart';
import 'layer_item_tree.dart';

/// Layer list, top layer first. The active layer receives new shapes; each
/// layer exports as its own method or class.
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
        return Column(children: [
          Row(children: [
            Text(
              context.l10n.layersTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            _btn(Icons.add, context.l10n.layerAdd,
                () => bloc.add(const LayerAdded())),
            _btn(Icons.edit_outlined, context.l10n.layerRename,
                () => _rename(context)),
            _btn(Icons.arrow_upward, context.l10n.layerMoveUp,
                () => bloc.add(LayerMoved(active, 1))),
            _btn(Icons.arrow_downward, context.l10n.layerMoveDown,
                () => bloc.add(LayerMoved(active, -1))),
            _btn(Icons.delete_outline, context.l10n.layerDelete,
                () => bloc.add(LayerDeleted(active))),
          ]).padding(left: 12),
          ListView.builder(
            itemCount: layers.length,
            itemBuilder: (context, row) {
              final i = layers.length - 1 - row;
              final l = layers[i];
              final layerIsActive = i == active;
              final itemCountKey = layerIsActive ? l.shapes.length : 0;
              final hasActiveImage = layerIsActive && l.image != null;
              final expansionKey = 'layer-$i-$itemCountKey-$hasActiveImage';
              final activeTileColor = layerIsActive
                  ? Theme.of(context).colorScheme.primaryContainer.withAlpha(90)
                  : null;
              return ExpansionTile(
                key: PageStorageKey(expansionKey),
                initiallyExpanded: layerIsActive,
                dense: true,
                tilePadding: const EdgeInsets.only(left: 8, right: 16),
                backgroundColor: activeTileColor,
                collapsedBackgroundColor: activeTileColor,
                onExpansionChanged: (expanded) {
                  if (expanded && i != bloc.state.layerIndex) {
                    bloc.add(LayerActivated(i));
                  }
                },
                leading: IconButton(
                  tooltip: l.visible
                      ? context.l10n.layerHide
                      : context.l10n.layerShow,
                  icon: Icon(
                    l.visible ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                  ),
                  onPressed: () => bloc.add(LayerVisibilityToggled(i)),
                ),
                title: Text(
                  l.name,
                  style: TextStyle(
                    color: layerIsActive
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
                subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (l.image != null)
                    const Icon(Icons.image_outlined, size: 14)
                        .padding(right: 6),
                  Text('${l.shapes.length}'),
                ]),
                children: [
                  LayerItemTree(layer: l, layerIndex: i, state: state),
                ],
              );
            },
          ).expanded(),
        ]);
      },
    );
  }

  Widget _btn(IconData icon, String tip, VoidCallback onPressed) => IconButton(
        tooltip: tip,
        iconSize: 18,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon),
        onPressed: onPressed,
      );
}
