// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/layer_ops.dart';
import '../editor/style_ops.dart';
import '../editor/vertex_ops.dart';
import '../editor/tool.dart';
import '../model/shape.dart';
import 'dialogs.dart';

/// Style controls. They edit the selected shape, or set the style used for the
/// next shapes when nothing is selected.
class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key, required this.controller});

  final EditorController controller;

  Future<void> _rename(BuildContext context, Shape s) async {
    final name = await promptText(context, title: 'Rename shape', initial: s.name);
    if (name != null) controller.renameSelected(name);
  }

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final s = c.selectedShape;
        final showRadius = c.tool == Tool.rect || s?.kind == ShapeKind.rect;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Properties', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            if (s == null)
              Text('No shape selected. These settings apply to the next shape you draw.',
                  style: Theme.of(context).textTheme.bodySmall)
            else ...[
              Row(children: [
                Expanded(child: Text(s.name.isEmpty ? s.kind.name : s.name)),
                IconButton(
                  tooltip: 'Rename shape',
                  iconSize: 18,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _rename(context, s),
                ),
              ]),
              Text(_bounds(s), style: Theme.of(context).textTheme.bodySmall),
              if (s.usesVertices && s.points.length >= 3)
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Closed shape (can be filled)'),
                  value: s.kind == ShapeKind.polygon,
                  onChanged: (v) => c.setClosed(v ?? false),
                ),
            ],
            const SizedBox(height: 8),
            _toggle('Fill', c.fillOn, c.fillColor, c.setFillOn, () => c.setEditFill(true)),
            _toggle('Stroke', c.strokeOn, c.strokeColor, c.setStrokeOn, () => c.setEditFill(false)),
            _slider('Stroke width', c.strokeWidth, 0.25, 20,
                (v) => c.setStrokeWidth(v, record: false), c.changed),
            if (showRadius)
              _slider('Corner radius', c.radius, 0, 40,
                  (v) => c.setRadius(v, record: false), c.changed),
            if (s != null) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                _action(Icons.copy, 'Duplicate', c.duplicateSelected),
                _action(Icons.delete_outline, 'Delete', c.deleteSelected),
                _action(Icons.flip_to_front, 'Forward', () => c.reorderSelected(1)),
                _action(Icons.flip_to_back, 'Back', () => c.reorderSelected(-1)),
                PopupMenuButton<int>(
                  tooltip: 'Move to layer',
                  onSelected: c.moveSelectedToLayer,
                  itemBuilder: (_) => [
                    for (var i = c.drawing.layers.length - 1; i >= 0; i--)
                      PopupMenuItem(value: i, child: Text(c.drawing.layers[i].name)),
                  ],
                  child: const Chip(avatar: Icon(Icons.layers, size: 16), label: Text('To layer')),
                ),
              ]),
            ],
          ]),
        );
      },
    );
  }

  String _bounds(Shape s) {
    final b = s.bounds;
    String f(double v) => v.toStringAsFixed(1);
    return 'x ${f(b.left)}  y ${f(b.top)}  w ${f(b.width)}  h ${f(b.height)}';
  }

  Widget _toggle(String label, bool on, int color, ValueChanged<bool> set, VoidCallback pick) {
    return Row(children: [
      Checkbox(value: on, onChanged: (v) => set(v ?? false)),
      Text(label),
      const Spacer(),
      GestureDetector(
        onTap: pick,
        child: Container(
          width: 28,
          height: 20,
          decoration: BoxDecoration(
            color: Color(color),
            border: Border.all(color: Colors.white54),
          ),
        ),
      ),
    ]);
  }

  Widget _slider(String label, double value, double min, double max,
      ValueChanged<double> onChanged, VoidCallback onEnd) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ${value.toStringAsFixed(2)}'),
      Slider(
        value: value.clamp(min, max).toDouble(),
        min: min,
        max: max,
        onChanged: (v) => onChanged((v * 4).round() / 4),
        onChangeEnd: (_) => onEnd(),
      ),
    ]);
  }

  Widget _action(IconData icon, String label, VoidCallback onPressed) =>
      OutlinedButton.icon(onPressed: onPressed, icon: Icon(icon, size: 16), label: Text(label));
}
