// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../editor/logic/editor_ops.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Image tab.
List<Widget> imageTabGroups(WorkspaceCommands c) {
  final img = c.state.layer.image;
  return [
    RibbonGroup(
      label: 'Picture',
      children: [
        RibbonButton.large(
          c.imageLoad,
          label: img == null ? 'Load' : 'Replace',
        ),
        RibbonButton.large(c.imageLoadNewLayer, label: 'On new layer'),
      ],
    ),
    RibbonGroup(
      label: 'Arrange',
      children: [
        RibbonStack(
          children: [
            RibbonButton.small(c.imageSelect),
            RibbonButton.small(c.imageTool),
            RibbonButton.small(c.imageFit),
          ],
        ),
      ],
    ),
    RibbonGroup(
      label: 'Adjust',
      children: [
        RibbonStack(
          children: [
            RibbonButton.small(c.imageVisible),
            RibbonSlider(
              label: 'Opacity ${((img?.opacity ?? 0.5) * 100).round()}%',
              value: img?.opacity ?? 0.5,
              min: 0.05,
              max: 1,
              onChanged: img == null ? null : c.setImageOpacity,
              onChangeEnd: c.commitChanges,
            ),
            RibbonSlider(
              label: 'Scale ${(img?.scaleX ?? 1).toStringAsFixed(3)}',
              value: img?.scaleX ?? 1,
              min: WorkspaceCommands.scaleMin(img?.scaleX ?? 1),
              max: WorkspaceCommands.scaleMax(img?.scaleX ?? 1),
              onChanged: img == null ? null : c.setImageScale,
              onChangeEnd: c.commitChanges,
            ),
          ],
        ),
      ],
    ),
    RibbonGroup(
      label: 'Remove',
      children: [RibbonButton.large(c.imageRemove, label: 'Remove')],
    ),
  ];
}
