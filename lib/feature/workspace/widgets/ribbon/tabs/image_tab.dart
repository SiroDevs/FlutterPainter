// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../editor/logic/drawing/editor_ops.dart';
import '../../../commands/workspace_commands.dart';
import '../ribbon_parts.dart';

// The groups of the Image tab.
List<Widget> imageTabGroups(WorkspaceCommands c) {
  final img = c.state.layer.image;
  return [
    RibbonGroup(
      label: c.context.l10n.ribbonPicture,
      children: [
        RibbonButton.large(
          c.imageLoad,
          label: img == null
              ? c.context.l10n.buttonLoad
              : c.context.l10n.buttonReplace,
        ),
        RibbonButton.large(
          c.imageLoadNewLayer,
          label: c.context.l10n.ribbonOnNewLayer,
        ),
      ],
    ),
    RibbonGroup(
      label: c.context.l10n.ribbonArrangeTab,
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
      label: c.context.l10n.ribbonAdjust,
      children: [
        RibbonStack(
          children: [
            RibbonButton.small(c.imageVisible),
            RibbonSlider(
              label: c.context.l10n.imageOpacity(
                ((img?.opacity ?? 0.5) * 100).round().toString(),
              ),
              value: img?.opacity ?? 0.5,
              min: 0.05,
              max: 1,
              onChanged: img == null ? null : c.setImageOpacity,
              onChangeEnd: c.commitChanges,
            ),
            RibbonSlider(
              label: c.context.l10n.imageScale(
                (img?.scaleX ?? 1).toStringAsFixed(3),
              ),
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
      label: c.context.l10n.imageRemove,
      children: [
        RibbonButton.large(c.imageRemove, label: c.context.l10n.imageRemove),
      ],
    ),
  ];
}
