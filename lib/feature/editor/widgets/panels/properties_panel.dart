// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../common/widgets/inputs/labeled_slider.dart';
import '../../../../domain/models/shape.dart';
import '../../../../domain/models/shape_kind.dart';
import '../../../../domain/models/tool.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/editor_ops.dart';

/// Style controls. They edit the selected shape, or set the style used for the
/// next shapes when nothing is selected.
class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  Future<void> _rename(BuildContext context, Shape s) async {
    final bloc = context.read<EditorBloc>();
    final name = await promptText(context, title: 'Rename shape', initial: s.name);
    if (name != null) bloc.add(EditorEvent.shapeRenamed(name));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        final s = state.selectedShape;
        final st = state.style;
        final showRadius = state.tool == Tool.rect || s?.kind == ShapeKind.rect;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Properties', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            if (s == null)
              Text(
                'No shape selected. These settings apply to the next shape you draw.',
                style: Theme.of(context).textTheme.bodySmall,
              )
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
                  onChanged: (v) => bloc.add(EditorEvent.closedToggled(v ?? false)),
                ),
            ],
            const SizedBox(height: 8),
            _toggle('Fill', st.fillOn, st.fillColor,
                (v) => bloc.add(EditorEvent.fillToggled(v)),
                () => bloc.add(const EditorEvent.styleTargetChanged(true))),
            _toggle('Stroke', st.strokeOn, st.strokeColor,
                (v) => bloc.add(EditorEvent.strokeToggled(v)),
                () => bloc.add(const EditorEvent.styleTargetChanged(false))),
            LabeledSlider(
              label: 'Stroke width: ${st.strokeWidth.toStringAsFixed(2)}',
              value: st.strokeWidth,
              min: 0.25,
              max: 20,
              onChanged: (v) =>
                  bloc.add(EditorEvent.strokeWidthChanged((v * 4).round() / 4)),
              onChangeEnd: () => bloc.add(const EditorEvent.changesCommitted()),
            ),
            if (showRadius)
              LabeledSlider(
                label: 'Corner radius: ${st.radius.toStringAsFixed(2)}',
                value: st.radius,
                min: 0,
                max: 40,
                onChanged: (v) =>
                    bloc.add(EditorEvent.radiusChanged((v * 4).round() / 4)),
                onChangeEnd: () => bloc.add(const EditorEvent.changesCommitted()),
              ),
            if (s != null) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                _action(Icons.copy, 'Duplicate',
                    () => bloc.add(const EditorEvent.shapeDuplicated())),
                _action(Icons.delete_outline, 'Delete',
                    () => bloc.add(const EditorEvent.shapeDeleted())),
                _action(Icons.flip_to_front, 'Forward',
                    () => bloc.add(const EditorEvent.shapeReordered(1))),
                _action(Icons.flip_to_back, 'Back',
                    () => bloc.add(const EditorEvent.shapeReordered(-1))),
                PopupMenuButton<int>(
                  tooltip: 'Move to layer',
                  onSelected: (i) => bloc.add(EditorEvent.shapeMovedToLayer(i)),
                  itemBuilder: (_) => [
                    for (var i = state.drawing.layers.length - 1; i >= 0; i--)
                      PopupMenuItem(value: i, child: Text(state.drawing.layers[i].name)),
                  ],
                  child: const Chip(
                    avatar: Icon(Icons.layers, size: 16),
                    label: Text('To layer'),
                  ),
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

  Widget _toggle(
    String label,
    bool on,
    int color,
    ValueChanged<bool> set,
    VoidCallback pick,
  ) {
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

  Widget _action(IconData icon, String label, VoidCallback onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
      );
}
