// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../domain/models/drawing.dart';
import '../../../domain/models/export_file.dart';
import '../../../domain/models/export_options.dart';
import '../../../domain/services/dart_exporter.dart';
import '../../../domain/services/dart_formatter.dart';

part 'export_state.dart';

/// The code editor's files: the generated sources, which of them are open in
/// tabs, and the user's edits. Nothing here touches the disk; the files are
/// temporary until the user saves them.
class ExportCubit extends Cubit<ExportState> {
  ExportCubit(this._drawing, ExportOptions options)
      : super(_generate(_drawing, options));

  final Drawing _drawing;

  static ExportState _generate(
    Drawing drawing,
    ExportOptions options, {
    List<String> keepOpen = const [],
    String? keepActive,
  }) {
    final exporter = DartExporter(drawing, options: options);
    final files = exporter.generate();
    final paths = {for (final f in files) f.path};
    var open = [for (final p in keepOpen) if (paths.contains(p)) p];
    if (open.isEmpty && files.isNotEmpty) open = [files.first.path];
    final active = keepActive != null && open.contains(keepActive)
        ? keepActive
        : (open.isEmpty ? null : open.first);
    return ExportState(
      folderName: exporter.folderName,
      files: files,
      originals: {for (final f in files) f.path: f.content},
      openPaths: open,
      activePath: active,
    );
  }

  /// Rebuilds every file from the drawing with new [options]. Edits are lost;
  /// the files that were open stay open.
  void regenerate(ExportOptions options) {
    emit(_generate(
      _drawing,
      options,
      keepOpen: state.openPaths,
      keepActive: state.activePath,
    ).copyWith(status: 'Regenerated ${state.files.length} file(s)'));
  }

  /// Opens [path] in a tab (if it is not already) and shows it.
  void open(String path) {
    if (state.fileAt(path) == null) return;
    emit(state.copyWith(
      openPaths: state.openPaths.contains(path)
          ? state.openPaths
          : [...state.openPaths, path],
      activePath: path,
    ));
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
      active = open.isEmpty ? null : open[i < open.length ? i : open.length - 1];
    }
    emit(state.copyWith(openPaths: open, activePath: active));
  }

  /// Records the editor's text for [path].
  void edit(String path, String content) {
    final file = state.fileAt(path);
    if (file == null || file.content == content) return;
    emit(state.copyWith(
      files: [
        for (final f in state.files) f.path == path ? f.withContent(content) : f,
      ],
    ));
  }

  /// Formats the active file.
  void formatActive() {
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
    final file = state.activeFile;
    if (file == null) return;
    await Clipboard.setData(ClipboardData(text: file.content));
    setStatus('Copied ${file.name} to the clipboard');
  }

  void setStatus(String status) => emit(state.copyWith(status: status));
}
