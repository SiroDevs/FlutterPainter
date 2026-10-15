// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/widgets/inputs/labeled_slider.dart';
import '../../../../domain/models/tool.dart';
import '../../bloc/editor_bloc.dart';
import '../../flows/image_flow.dart';
import '../../logic/editor_ops.dart';

/// The picture on the active layer, for tracing or as a backdrop. Every layer
/// can hold its own, so switching layers switches pictures; drag one on the
/// canvas to move it, and drag its handles to resize or stretch it.
class ImagePanel extends StatelessWidget {
  const ImagePanel({super.key});

  static String _n(double v) => v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) =>
          a.layerIndex != b.layerIndex ||
          a.layer.image != b.layer.image ||
          !identical(a.images, b.images),
      builder: (context, state) {
        final r = state.layer.image;
        final box = state.imageBounds;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(
                'Image on "${state.layer.name}"',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ).expanded(),
              IconButton(
                tooltip: 'Load an image onto a new layer',
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.library_add_outlined),
                onPressed: () =>
                    chooseLayerImage(context, bloc, onNewLayer: true),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: () => chooseLayerImage(context, bloc),
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(r == null ? 'Load' : 'Replace'),
              ),
            ]),
            if (r == null)
              Text(
                'Load a picture onto this layer to trace over or use as a '
                'backdrop. Add layers for more pictures, or drop an image '
                'file onto the window.',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else ...[
              Row(children: [
                Checkbox(
                  value: r.visible,
                  onChanged: (v) => bloc.add(ImageVisibilityChanged(v ?? true)),
                ),
                const Text('Show'),
                const Spacer(),
                IconButton(
                  tooltip: 'Select image (shows resize handles)',
                  iconSize: 18,
                  icon: const Icon(Icons.crop_free),
                  onPressed: () => bloc.add(const ImageSelected()),
                ),
                IconButton(
                  tooltip: 'Move / resize image (tool)',
                  iconSize: 18,
                  icon: const Icon(Icons.open_with),
                  onPressed: () => bloc.add(const ToolSelected(Tool.reference)),
                ),
                IconButton(
                  tooltip: 'Fit to canvas (resets stretch)',
                  iconSize: 18,
                  icon: const Icon(Icons.fit_screen),
                  onPressed: () => bloc.add(const ImageFitted()),
                ),
                IconButton(
                  tooltip: 'Remove image',
                  iconSize: 18,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => bloc.add(const ImageRemoved()),
                ),
              ]),
              if (box != null)
                Text(
                  '${_n(box.width)} × ${_n(box.height)} at '
                  '(${_n(box.left)}, ${_n(box.top)})',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              LabeledSlider(
                compact: true,
                label: 'Opacity ${(r.opacity * 100).round()}%',
                value: r.opacity,
                min: 0.05,
                max: 1,
                onChanged: (v) => bloc.add(ImageOpacityChanged(v)),
                onChangeEnd: () => bloc.add(const ChangesCommitted()),
              ),
              LabeledSlider(
                compact: true,
                label: 'Scale ${r.scaleX.toStringAsFixed(3)}',
                value: r.scaleX,
                min: math.min(0.01, r.scaleX),
                max: math.max(4.0, r.scaleX * 1.5),
                onChanged: (v) => bloc.add(ImageScaleChanged(v)),
                onChangeEnd: () => bloc.add(const ChangesCommitted()),
              ),
            ],
          ]).padding(horizontal: 12, vertical: 8);
      },
    );
  }
}
