part of 'inline_code_cubit.dart';

// What the status line under the inline code view reports.
enum InlineCodeStatus { idle, rendered, unreadable }

class InlineCodeState extends Equatable {
  const InlineCodeState({
    required this.files,
    required this.removablePaths,
    this.activePath,
    this.status = InlineCodeStatus.idle,
    this.skippedCount = 0,
  });

  final List<ExportFile> files;

  // Files that stand for a layer, so removing them removes that layer.
  final Set<String> removablePaths;
  final String? activePath;
  final InlineCodeStatus status;
  final int skippedCount;

  ExportFile? get activeFile => fileAt(activePath);

  ExportFile? fileAt(String? path) {
    for (final file in files) {
      if (file.path == path) return file;
    }
    return null;
  }

  InlineCodeState copyWith({
    List<ExportFile>? files,
    Set<String>? removablePaths,
    Object? activePath = unset,
    InlineCodeStatus? status,
    int? skippedCount,
  }) =>
      InlineCodeState(
        files: files ?? this.files,
        removablePaths: removablePaths ?? this.removablePaths,
        activePath: keep<String>(activePath, this.activePath),
        status: status ?? this.status,
        skippedCount: skippedCount ?? this.skippedCount,
      );

  @override
  List<Object?> get props =>
      [files, removablePaths, activePath, status, skippedCount];
}
