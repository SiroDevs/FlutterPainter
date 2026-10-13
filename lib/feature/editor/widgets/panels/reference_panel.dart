// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/widgets/inputs/labeled_slider.dart';
import '../../../../domain/models/tool.dart';
import '../../flows/reference_flow.dart';
import '../../bloc/editor_bloc.dart';

/// Background image for tracing: load it, fade it, scale it, drag it into place
/// with the "Move background image" tool, then draw over it.
class ReferencePanel extends StatelessWidget {
  const ReferencePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) => a.drawing.reference != b.drawing.reference,
      builder: (context, state) {
        final r = state.drawing.reference;
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Background image', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: () => chooseReferenceImage(context, bloc),
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(r == null ? 'Load' : 'Replace'),
              ),
            ]),
            if (r == null)
              Text(
                'Load a picture to trace over. You can also drop an image file onto the window.',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else ...[
              Row(children: [
                Checkbox(
                  value: r.visible,
                  onChanged: (v) =>
                      bloc.add(ReferenceVisibilityChanged(v ?? true)),
                ),
                const Text('Show'),
                const Spacer(),
                IconButton(
                  tooltip: 'Move image (tool)',
                  iconSize: 18,
                  icon: const Icon(Icons.open_with),
                  onPressed: () => bloc.add(const ToolSelected(Tool.reference)),
                ),
                IconButton(
                  tooltip: 'Fit to canvas',
                  iconSize: 18,
                  icon: const Icon(Icons.fit_screen),
                  onPressed: () => bloc.add(const ReferenceFitted()),
                ),
                IconButton(
                  tooltip: 'Remove image',
                  iconSize: 18,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => bloc.add(const ReferenceRemoved()),
                ),
              ]),
              LabeledSlider(
                compact: true,
                label: 'Opacity ${(r.opacity * 100).round()}%',
                value: r.opacity,
                min: 0.05,
                max: 1,
                onChanged: (v) => bloc.add(ReferenceOpacityChanged(v)),
                onChangeEnd: () => bloc.add(const ChangesCommitted()),
              ),
              LabeledSlider(
                compact: true,
                label: 'Scale ${r.scale.toStringAsFixed(3)}',
                value: r.scale,
                min: 0.01,
                max: 4,
                onChanged: (v) => bloc.add(ReferenceScaleChanged(v)),
                onChangeEnd: () => bloc.add(const ChangesCommitted()),
              ),
            ],
          ]),
        );
      },
    );
  }
}
