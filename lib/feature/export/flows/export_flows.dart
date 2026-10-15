// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/widgets/progress/custom_snackbar.dart';
import '../../../core/di/injectable.dart';
import '../../../core/platform/file_dialogs.dart';
import '../../../core/utils/zip_writer.dart';
import '../cubit/export_cubit.dart';

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
  final dialogs = getIt<FileDialogs>();
  try {
    final directory = await dialogs.pickDirectory();
    if (directory == null) return;
    final state = cubit.state;
    final files = {
      for (final f in state.files) '${state.folderName}/${f.path}': f.content,
    };
    final existing = await dialogs.existingFiles(directory, files.keys.toList());
    if (existing.isNotEmpty) {
      if (!context.mounted) return;
      final ok = await confirm(
        context,
        title: 'Replace existing files?',
        message: '${existing.length} of ${files.length} files already exist in '
            'that folder and will be overwritten.',
        confirmLabel: 'Replace',
      );
      if (!ok) return;
    }
    await dialogs.writeTextFiles(directory, files);
    if (!context.mounted) return;
    _report(
      context,
      cubit,
      'Saved ${files.length} file(s) to $directory/${state.folderName}',
    );
  } catch (e) {
    if (context.mounted) _report(context, cubit, 'Could not save: $e', error: true);
  }
}

/// Packs every file into one .zip the user names.
Future<void> saveArchive(BuildContext context, ExportCubit cubit) async {
  final dialogs = getIt<FileDialogs>();
  try {
    final state = cubit.state;
    final bytes = buildZip([
      for (final f in state.files)
        ZipItem(
          '${state.folderName}/${f.path}',
          Uint8List.fromList(utf8.encode(f.content)),
        ),
    ]);
    final path = await dialogs.saveArchive(
      bytes,
      suggestedName: '${state.folderName}.zip',
    );
    if (path == null || !context.mounted) return;
    _report(context, cubit, 'Saved ${state.files.length} file(s) to $path');
  } catch (e) {
    if (context.mounted) _report(context, cubit, 'Could not save: $e', error: true);
  }
}
