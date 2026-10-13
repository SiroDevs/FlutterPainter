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
}
