// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../domain/models/drawing/drawing.dart';
import '../../../domain/models/export/export_file.dart';
import '../../../domain/models/export/export_options.dart';
import '../../../domain/services/code_export/code_format.dart';
import '../../../domain/services/code_export/dart_formatter.dart';
import 'export_jobs.dart';

part 'export_state.dart';

/// The code editor's files: the generated sources, which of them are open in
/// tabs, and the user's edits. Nothing here touches the disk; the files are
/// temporary until the user saves them.
class ExportCubit extends Cubit<ExportState> {
  ExportCubit(Drawing drawing, ExportOptions options)
    : _drawing = drawing,
      super(
        ExportState(
          folderName: snakeCase(pascalCase(drawing.name)),
          files: const [],
          originals: const {},
          openPaths: const [],
          activePath: null,
          isGenerating: true,
        ),
      ) {
    unawaited(regenerate(options));
  }

  final Drawing _drawing;
  int _generation = 0;

  /// Rebuilds every file from the drawing with new [options]. Edits are lost;
  /// the files that were open stay open.
  Future<void> regenerate(ExportOptions options) async {
    final generation = ++_generation;
    emit(
      state.copyWith(isGenerating: true, generationFailed: false, status: ''),
    );
    try {
      final generated = await generateExportFiles(_drawing, options);
      if (isClosed || generation != _generation) return;
      final paths = {for (final file in generated.files) file.path};
      var openPaths = [
        for (final path in state.openPaths)
          if (paths.contains(path)) path,
      ];
      if (openPaths.isEmpty && generated.files.isNotEmpty) {
        openPaths = [generated.files.first.path];
      }
      final activePath =
          state.activePath != null && openPaths.contains(state.activePath)
          ? state.activePath
          : (openPaths.isEmpty ? null : openPaths.first);
      emit(
        ExportState(
          folderName: generated.folderName,
          files: generated.files,
          originals: {
            for (final file in generated.files) file.path: file.content,
          },
          openPaths: openPaths,
          activePath: activePath,
          status: 'Regenerated ${generated.files.length} file(s)',
        ),
      );
    } catch (_) {
      if (isClosed || generation != _generation) return;
      emit(state.copyWith(isGenerating: false, generationFailed: true));
    }
  }

  /// Updates the archive or file-write progress state.
  void setSaving(bool isSaving) {
    if (!isClosed) emit(state.copyWith(isSaving: isSaving));
  }

  /// Opens [path] in a tab (if it is not already) and shows it.
  void open(String path) {
    if (state.fileAt(path) == null) return;
    emit(
      state.copyWith(
        openPaths: state.openPaths.contains(path)
            ? state.openPaths
            : [...state.openPaths, path],
        activePath: path,
      ),
    );
  }

  /// Shows an already-open tab.
  void select(String path) => emit(state.copyWith(activePath: path));

  /// Closes the tab for [path]. The file stays in the explorer; its edits are
  /// kept. The neighbour to the right (else left) becomes active.
  void closeTab(String path) {
    final i = state.openPaths.indexOf(path);
    if (i < 0) return;
    final open = [...state.openPaths]..removeAt(i);
    String? active = state.activePath;
    if (active == path) {
      active = open.isEmpty
          ? null
          : open[i < open.length ? i : open.length - 1];
    }
    emit(state.copyWith(openPaths: open, activePath: active));
  }

  /// Records the editor's text for [path].
  void edit(String path, String content) {
    if (state.isBusy) return;
    final file = state.fileAt(path);
    if (file == null || file.content == content) return;
    emit(
      state.copyWith(
        files: [
          for (final f in state.files)
            f.path == path ? f.withContent(content) : f,
        ],
      ),
    );
  }

  /// Formats the active file.
  void formatActive() {
    if (state.isBusy) return;
    final file = state.activeFile;
    if (file == null) return;
    final formatted = formatDart(file.content);
    if (formatted == file.content) {
      setStatus('${file.name} is already formatted');
      return;
    }
    edit(file.path, formatted);
    setStatus('Formatted ${file.name}');
  }

  Future<void> copyActive() async {
    if (state.isBusy) return;
    final file = state.activeFile;
    if (file == null) return;
    await Clipboard.setData(ClipboardData(text: file.content));
    setStatus('Copied ${file.name} to the clipboard');
  }

  void setStatus(String status) => emit(state.copyWith(status: status));
}
