// Package imports:
import 'package:equatable/equatable.dart';

/// One generated source file, held in memory until the user saves it.
class ExportFile extends Equatable {
  const ExportFile({required this.path, required this.content});

  /// Path inside the exported project, with `/` separators and no leading
  /// slash, e.g. `layers/body_layer.dart`.
  final String path;
  final String content;

  String get name => path.split('/').last;

  /// The folders above the file, e.g. `['layers']`; empty for a top-level file.
  List<String> get folders {
    final parts = path.split('/');
    return parts.sublist(0, parts.length - 1);
  }

  ExportFile withContent(String content) =>
      ExportFile(path: path, content: content);

  @override
  List<Object?> get props => [path, content];
}
