part of 'export_cubit.dart';

class ExportState extends Equatable {
  const ExportState({
    required this.folderName,
    required this.files,
    required this.originals,
    required this.openPaths,
    required this.activePath,
    this.status = '',
  });

  /// The project folder the files belong to, e.g. `rider`.
  final String folderName;

  /// Every file, with the user's edits.
  final List<ExportFile> files;

  /// What each file contained when it was generated, to tell which are edited.
  final Map<String, String> originals;

  /// The files open in tabs, left to right.
  final List<String> openPaths;
  final String? activePath;

  /// The last thing that happened, for the status bar.
  final String status;

  ExportFile? fileAt(String? path) {
    for (final f in files) {
      if (f.path == path) return f;
    }
    return null;
  }

  ExportFile? get activeFile => fileAt(activePath);

  bool isModified(String path) => fileAt(path)?.content != originals[path];

  bool get hasEdits => files.any((f) => f.content != originals[f.path]);

  /// The paths whose text differs from what was generated.
  Set<String> get modifiedPaths => {
        for (final f in files)
          if (f.content != originals[f.path]) f.path,
      };

  ExportState copyWith({
    List<ExportFile>? files,
    List<String>? openPaths,
    Object? activePath = _unset,
    String? status,
  }) =>
      ExportState(
        folderName: folderName,
        files: files ?? this.files,
        originals: originals,
        openPaths: openPaths ?? this.openPaths,
        activePath: identical(activePath, _unset)
            ? this.activePath
            : activePath as String?,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props =>
      [folderName, files, originals, openPaths, activePath, status];
}

const Object _unset = Object();
