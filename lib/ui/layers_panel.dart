// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/layer_ops.dart';
import 'dialogs.dart';

/// Layer list, top layer first. The active layer receives new shapes; each
/// layer exports as its own method or class.
class LayersPanel extends StatelessWidget {
  const LayersPanel({super.key, required this.controller});

  final EditorController controller;

  Future<void> _rename(BuildContext context) async {
    final c = controller;
    final name = await promptText(context, title: 'Rename layer', initial: c.layer.name);
    if (name != null && name.isNotEmpty) c.renameLayer(c.layerIndex, name);
  }

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final layers = c.drawing.layers;
        return Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(children: [
              Text('Layers', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _btn(Icons.add, 'Add layer', c.addLayer),
              _btn(Icons.edit_outlined, 'Rename layer', () => _rename(context)),
              _btn(Icons.arrow_upward, 'Move layer up', () => c.moveLayer(c.layerIndex, 1)),
              _btn(Icons.arrow_downward, 'Move layer down', () => c.moveLayer(c.layerIndex, -1)),
              _btn(Icons.delete_outline, 'Delete layer', () => c.deleteLayer(c.layerIndex)),
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
                  selected: i == c.layerIndex,
                  selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(90),
                  leading: IconButton(
                    tooltip: l.visible ? 'Hide' : 'Show',
                    icon: Icon(l.visible ? Icons.visibility : Icons.visibility_off, size: 18),
                    onPressed: () => c.toggleVisible(i),
                  ),
                  title: Text(l.name),
                  trailing: Text('${l.shapes.length}'),
                  onTap: () => c.setActiveLayer(i),
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
