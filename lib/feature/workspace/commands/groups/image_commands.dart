// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/editor/tool.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/flows/image_flow.dart';
import '../../../editor/logic/exports.dart';
import '../../../editor/widgets/toolbar/tool_info.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension ImageCommands on WorkspaceCommands {
  AppCommand get imageLoad => AppCommand(
    label: hasImage ? context.l10n.imageReplace : context.l10n.imageLoad,
    icon: Icons.add_photo_alternate_outlined,
    tooltip: context.l10n.imagePutLayerTooltip,
    onPressed: () => chooseLayerImage(context, bloc),
  );

  AppCommand get imageLoadNewLayer => AppCommand(
    label: context.l10n.imageLoadNewLayer,
    icon: Icons.library_add_outlined,
    tooltip: context.l10n.imageLoadNewLayerTooltip,
    onPressed: () => chooseLayerImage(context, bloc, onNewLayer: true),
  );

  AppCommand get imageSelect => AppCommand(
    label: context.l10n.imageSelect,
    icon: Icons.crop_free,
    tooltip: context.l10n.imageSelectTooltip,
    onPressed: hasImage ? () => send(const ImageSelected()) : null,
  );

  AppCommand get imageTool => AppCommand(
    label: context.l10n.imageMoveResize,
    icon: Icons.open_with,
    tooltip: context.l10n.imageMoveResizeTooltip,
    keys: Tool.reference.keyLabel,
    checked: state.tool == Tool.reference,
    onPressed: hasImage ? () => send(const ToolSelected(Tool.reference)) : null,
  );

  AppCommand get imageFit => AppCommand(
    label: context.l10n.imageFit,
    icon: Icons.fit_screen,
    tooltip: context.l10n.imageFitTooltip,
    onPressed: hasImage ? () => send(const ImageFitted()) : null,
  );

  AppCommand get imageVisible => AppCommand(
    label: context.l10n.imageShow,
    icon: Icons.image_outlined,
    checked: state.layer.image?.visible ?? false,
    onPressed: hasImage
        ? () => send(
            ImageVisibilityChanged(!(bloc.state.layer.image?.visible ?? true)),
          )
        : null,
  );

  AppCommand get imageRemove => AppCommand(
    label: context.l10n.imageRemove,
    icon: Icons.hide_image_outlined,
    onPressed: hasImage ? () => send(const ImageRemoved()) : null,
  );

  /// Slider drags apply at once; this records the history entry afterwards.
  void commitChanges() => send(const ChangesCommitted());
  void setImageOpacity(double v) => send(ImageOpacityChanged(v));
  void setImageScale(double v) => send(ImageScaleChanged(v));
}
