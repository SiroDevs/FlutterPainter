// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../editor/bloc/controller/editor_bloc.dart';
import 'setting_field.dart';

/// Shows the editable name and canvas dimensions of the active project.
class ProjectSettingsPage extends StatelessWidget {
  const ProjectSettingsPage({
    super.key,
    required this.editor,
    this.projectName,
  });

  final EditorBloc? editor;
  final String? projectName;

  @override
  Widget build(BuildContext context) {
    final activeEditor = editor;
    if (activeEditor == null) {
      final name = projectName;
      if (name != null) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.projectSettingsDescription),
              const SizedBox(height: 20),
              SettingField(
                label: context.l10n.projectCurrentName,
                child: Text(name),
              ),
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(context.l10n.projectUnavailable),
      );
    }
    return BlocBuilder<EditorBloc, EditorState>(
      bloc: activeEditor,
      builder: (context, state) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.projectSettingsDescription),
            const SizedBox(height: 20),
            SettingField(
              label: context.l10n.projectCurrentName,
              child: Row(
                children: [
                  Expanded(child: Text(state.drawing.name)),
                  OutlinedButton.icon(
                    onPressed: () => _rename(context, state.drawing.name),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(context.l10n.projectRename),
                  ),
                ],
              ),
            ),
            SettingField(
              label: context.l10n.projectCanvasSize,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.projectDimensions(
                        state.drawing.width.toStringAsFixed(0),
                        state.drawing.height.toStringAsFixed(0),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _resize(
                      context,
                      state.drawing.width,
                      state.drawing.height,
                    ),
                    icon: const Icon(Icons.aspect_ratio),
                    label: Text(context.l10n.projectResizeCanvas),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, String currentName) async {
    final name = await promptText(
      context,
      title: context.l10n.projectCurrentName,
      initial: currentName,
    );
    if (name != null && name.isNotEmpty) editor?.add(DrawingRenamed(name));
  }

  Future<void> _resize(
    BuildContext context,
    double width,
    double height,
  ) async {
    final size = await promptSize(context, width, height);
    if (size != null) editor?.add(CanvasResized(size.$1, size.$2));
  }
}
