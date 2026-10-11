// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/reference_ops.dart';
import '../editor/tool.dart';
import '../workspace/tab_actions.dart';

/// Background image for tracing: load it, fade it, scale it, drag it into place
/// with the "Move background image" tool, then draw over it.
class ReferencePanel extends StatelessWidget {
  const ReferencePanel({super.key, required this.controller});

  final EditorController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final r = c.drawing.reference;
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Background image', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: () => chooseReferenceImage(context, c),
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(r == null ? 'Load' : 'Replace'),
              ),
            ]),
            if (r == null)
              Text('Load a picture to trace over. You can also drop an image file onto the window.',
                  style: Theme.of(context).textTheme.bodySmall)
            else ...[
              Row(children: [
                Checkbox(
                  value: r.visible,
                  onChanged: (v) => c.editReference((i) => i.visible = v ?? true),
                ),
                const Text('Show'),
                const Spacer(),
                IconButton(
                  tooltip: 'Move image (tool)',
                  iconSize: 18,
                  icon: const Icon(Icons.open_with),
                  onPressed: () => c.setTool(Tool.reference),
                ),
                IconButton(
                  tooltip: 'Fit to canvas',
                  iconSize: 18,
                  icon: const Icon(Icons.fit_screen),
                  onPressed: c.fitReference,
                ),
                IconButton(
                  tooltip: 'Remove image',
                  iconSize: 18,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: c.removeReference,
                ),
              ]),
              _slider('Opacity ${(r.opacity * 100).round()}%', r.opacity, 0.05, 1,
                  (v) => c.editReference((i) => i.opacity = v, record: false)),
              _slider('Scale ${r.scale.toStringAsFixed(3)}', r.scale, 0.01, 4,
                  (v) => c.setReferenceScale(v, record: false)),
            ],
          ]),
        );
      },
    );
  }

  Widget _slider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12)),
      SizedBox(
        height: 28,
        child: Slider(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max,
          onChanged: onChanged,
          onChangeEnd: (_) => controller.changed(),
        ),
      ),
    ]);
  }
}
