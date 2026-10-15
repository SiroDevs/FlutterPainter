// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:file_selector/file_selector.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../common/constants/app_constants.dart';

/// Native open/save dialogs and raw file reads, behind one injectable class so
/// the rest of the app (and its tests) never touches the platform directly.
@lazySingleton
class FileDialogs {
  static const _projectFiles = XTypeGroup(
    label: 'Flutter Painter Project',
    extensions: [AppConstants.projectExtension, 'json'],
  );
  static const _flpOnly = XTypeGroup(
    label: 'Flutter Painter Project',
    extensions: [AppConstants.projectExtension],
  );
  static const _imageFiles = XTypeGroup(
    label: 'Images',
    extensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp', 'gif'],
  );
  static const _dartFiles = XTypeGroup(label: 'Dart', extensions: ['dart']);
  static const _zipFiles = XTypeGroup(label: 'Zip archive', extensions: ['zip']);

  /// Asks where to save a project. Always returns a path ending in .flp.
  Future<String?> pickSavePath() async {
    final location = await getSaveLocation(acceptedTypeGroups: [_flpOnly]);
    if (location == null) return null;
    final path = location.path;
    return path.toLowerCase().endsWith('.${AppConstants.projectExtension}')
        ? path
        : '$path.${AppConstants.projectExtension}';
  }

  Future<List<String>> pickProjectPaths() async {
    final files = await openFiles(acceptedTypeGroups: [_projectFiles]);
    return [for (final f in files) f.path];
  }

  Future<Uint8List?> pickImageBytes() async {
    final file = await openFile(acceptedTypeGroups: [_imageFiles]);
    return file?.readAsBytes();
  }

  Future<Uint8List> readBytes(String path) => File(path).readAsBytes();

  /// Writes exported code to a file the user picks. Returns the path or null.
  Future<String?> saveDartFile(String code) async {
    final location = await getSaveLocation(acceptedTypeGroups: [_dartFiles]);
    if (location == null) return null;
    var path = location.path;
    if (!path.toLowerCase().endsWith('.dart')) path = '$path.dart';
    await File(path).writeAsString(code);
    return path;
  }

  /// Asks for a folder to write into. Null if the user cancels.
  Future<String?> pickDirectory() =>
      getDirectoryPath(confirmButtonText: 'Save here');

  static String _join(String directory, String relative) {
    final sep = Platform.pathSeparator;
    final base = directory.endsWith(sep)
        ? directory.substring(0, directory.length - 1)
        : directory;
    return '$base$sep${relative.replaceAll('/', sep)}';
  }

  /// The paths in [relativePaths] that already exist under [directory].
  Future<List<String>> existingFiles(
    String directory,
    List<String> relativePaths,
  ) async => [
        for (final p in relativePaths)
          if (await File(_join(directory, p)).exists()) p,
      ];

  /// Writes each file (relative path -> text) under [directory], creating any
  /// folders it needs. Returns the folder that was written to.
  Future<String> writeTextFiles(
    String directory,
    Map<String, String> files,
  ) async {
    for (final entry in files.entries) {
      final file = File(_join(directory, entry.key));
      await file.parent.create(recursive: true);
      await file.writeAsString(entry.value);
    }
    return directory;
  }

  /// Saves a zip archive to a file the user picks. Returns the path or null.
  Future<String?> saveArchive(
    Uint8List bytes, {
    required String suggestedName,
  }) async {
    final location = await getSaveLocation(
      suggestedName: suggestedName,
      acceptedTypeGroups: [_zipFiles],
    );
    if (location == null) return null;
    var path = location.path;
    if (!path.toLowerCase().endsWith('.zip')) path = '$path.zip';
    await File(path).writeAsBytes(bytes);
    return path;
  }
}
