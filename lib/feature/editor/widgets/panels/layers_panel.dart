// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/editor_ops.dart';

/// Layer list, top layer first. The active layer receives new shapes; each
/// layer exports as its own method or class.
class LayersPanel extends StatelessWidget {
  const LayersPanel({super.key});

  Future<void> _rename(BuildContext context) async {
    final bloc = context.read<EditorBloc>();
    final state = bloc.state;
    final name = await promptText(
      context,
      title: 'Rename layer',
      initial: state.layer.name,
    );
    if (name != null && name.isNotEmpty) {
      bloc.add(EditorEvent.layerRenamed(state.layerIndex, name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) =>
          a.layerIndex != b.layerIndex || a.drawing.layers != b.drawing.layers,
      builder: (context, state) {
        final layers = state.drawing.layers;
        final active = state.layerIndex;
        return Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(children: [
              Text('Layers', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _btn(Icons.add, 'Add layer', () => bloc.add(const EditorEvent.layerAdded())),
              _btn(Icons.edit_outlined, 'Rename layer', () => _rename(context)),
              _btn(Icons.arrow_upward, 'Move layer up',
                  () => bloc.add(EditorEvent.layerMoved(active, 1))),
              _btn(Icons.arrow_downward, 'Move layer down',
                  () => bloc.add(EditorEvent.layerMoved(active, -1))),
              _btn(Icons.delete_outline, 'Delete layer',
                  () => bloc.add(EditorEvent.layerDeleted(active))),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: layers.length,
              itemBuilder: (context, row) {
                final i = layers.length - 1 - row;
                final l = layers[i];
                return ListTile(
                  dense: true,
                  selected: i == active,
                  selectedTileColor:
                      Theme.of(context).colorScheme.primaryContainer.withAlpha(90),
                  leading: IconButton(
                    tooltip: l.visible ? 'Hide' : 'Show',
                    icon: Icon(
                      l.visible ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                    ),
                    onPressed: () => bloc.add(EditorEvent.layerVisibilityToggled(i)),
                  ),
                  title: Text(l.name),
                  trailing: Text('${l.shapes.length}'),
                  onTap: () => bloc.add(EditorEvent.layerActivated(i)),
                );
              },
            ),
          ),
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
