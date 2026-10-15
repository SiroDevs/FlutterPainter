// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../domain/models/tool.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/flows/image_flow.dart';
import '../../../editor/logic/exports.dart';
import '../../../editor/widgets/toolbar/tool_info.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension ImageCommands on WorkspaceCommands {
  AppCommand get imageLoad => AppCommand(
        label: hasImage ? 'Replace image…' : 'Load image…',
        icon: Icons.add_photo_alternate_outlined,
        tooltip: 'Put a picture on this layer',
        onPressed: () => chooseLayerImage(context, bloc),
      );

  AppCommand get imageLoadNewLayer => AppCommand(
        label: 'Image on new layer…',
        icon: Icons.library_add_outlined,
        tooltip: 'Load a picture onto a new layer',
        onPressed: () => chooseLayerImage(context, bloc, onNewLayer: true),
      );

  AppCommand get imageSelect => AppCommand(
        label: 'Select image',
        icon: Icons.crop_free,
        tooltip: 'Select this layer\'s image (shows resize handles)',
        onPressed: hasImage ? () => send(const ImageSelected()) : null,
      );

  AppCommand get imageTool => AppCommand(
        label: 'Move / resize image',
        icon: Icons.open_with,
        tooltip: 'Move / resize image tool',
        keys: Tool.reference.keyLabel,
        checked: state.tool == Tool.reference,
        onPressed: hasImage ? () => send(const ToolSelected(Tool.reference)) : null,
      );

  AppCommand get imageFit => AppCommand(
        label: 'Fit image to canvas',
        icon: Icons.fit_screen,
        tooltip: 'Fit the image to the canvas (resets stretch)',
        onPressed: hasImage ? () => send(const ImageFitted()) : null,
      );

  AppCommand get imageVisible => AppCommand(
        label: 'Show image',
        icon: Icons.image_outlined,
        checked: state.layer.image?.visible ?? false,
        onPressed: hasImage
            ? () => send(ImageVisibilityChanged(
                  !(bloc.state.layer.image?.visible ?? true),
                ))
            : null,
      );

  AppCommand get imageRemove => AppCommand(
        label: 'Remove image',
        icon: Icons.hide_image_outlined,
        onPressed: hasImage ? () => send(const ImageRemoved()) : null,
      );

  /// Slider drags apply at once; this records the history entry afterwards.
  void commitChanges() => send(const ChangesCommitted());
  void setImageOpacity(double v) => send(ImageOpacityChanged(v));
  void setImageScale(double v) => send(ImageScaleChanged(v));
}
