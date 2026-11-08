// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/widgets/progress/custom_snackbar.dart';
import '../../../core/di/injectable.dart';
import '../../../core/platform/file_dialogs.dart';
import '../cubit/export_cubit.dart';
import '../cubit/export_jobs.dart';

/// Asks a yes/no question in a small dialog.
Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return answer ?? false;
}

void _report(
  BuildContext context,
  ExportCubit cubit,
  String message, {
  bool error = false,
}) {
  cubit.setStatus(message);
  if (error && context.mounted) CustomSnackbar.show(context, message);
}

/// Writes every file into a folder the user picks, inside a sub-folder named
/// after the project (so it can be dropped into `lib/`).
Future<void> saveLocally(BuildContext context, ExportCubit cubit) async {
  if (cubit.state.isBusy) return;
  final dialogs = getIt<FileDialogs>();
  try {
    final directory = await dialogs.pickDirectory();
    if (directory == null) return;
    final state = cubit.state;
    final files = {
      for (final f in state.files) '${state.folderName}/${f.path}': f.content,
    };
    final existing = await dialogs.existingFiles(
      directory,
      files.keys.toList(),
    );
    if (existing.isNotEmpty) {
      if (!context.mounted) return;
      final ok = await confirm(
        context,
        title: 'Replace existing files?',
        message:
            '${existing.length} of ${files.length} files already exist in '
            'that folder and will be overwritten.',
        confirmLabel: 'Replace',
      );
      if (!ok) return;
    }
    cubit.setSaving(true);
    try {
      await dialogs.writeTextFiles(directory, files);
    } finally {
      cubit.setSaving(false);
    }
    if (!context.mounted) return;
    _report(
      context,
      cubit,
      'Saved ${files.length} file(s) to $directory/${state.folderName}',
    );
  } catch (e) {
    if (context.mounted) {
      _report(context, cubit, 'Could not save: $e', error: true);
    }
  }
}

/// Packs every file into one .zip the user names.
Future<void> saveArchive(BuildContext context, ExportCubit cubit) async {
  if (cubit.state.isBusy) return;
  final dialogs = getIt<FileDialogs>();
  try {
    final state = cubit.state;
    cubit.setSaving(true);
    try {
      final bytes = await buildExportArchive(state.folderName, state.files);
      final path = await dialogs.saveArchive(
        bytes,
        suggestedName: '${state.folderName}.zip',
      );
      if (path == null || !context.mounted) return;
      _report(context, cubit, 'Saved ${state.files.length} file(s) to $path');
    } finally {
      cubit.setSaving(false);
    }
  } catch (e) {
    if (context.mounted) {
      _report(context, cubit, 'Could not save: $e', error: true);
    }
  }
}
