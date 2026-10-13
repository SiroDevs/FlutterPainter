// Dart imports:
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';

/// Reads and writes project files as text on disk.
@lazySingleton
class ProjectFileSource {
  Future<String> read(String path) => File(path).readAsString();

  /// Writes next to the target and renames over it, so a crash mid-write can
  /// never leave a half-written project behind. Where the OS only allows
  /// touching the chosen file itself (macOS sandbox), it writes that file directly.
  Future<void> write(String path, String text) async {
    final temp = File('$path.tmp');
    try {
      await temp.writeAsString(text, flush: true);
      await temp.rename(path);
    } on FileSystemException {
      try {
        if (await temp.exists()) await temp.delete();
      } on FileSystemException {
        // ignored: the direct write below reports any real failure
      }
      await File(path).writeAsString(text, flush: true);
    }
  }
}