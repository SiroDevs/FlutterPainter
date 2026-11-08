// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';

/// Reads and writes project files as text on disk.
@lazySingleton
class ProjectFileSource {
  Future<String> read(String path) => File(path).readAsString();

  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  /// Writes next to the target and renames over it, so a crash mid-write can
  /// never leave a half-written project behind. Where the OS only allows
  /// touching the chosen file itself (macOS sandbox), it writes that file directly.
  Future<void> write(String path, String text) async {
    await File(path).parent.create(recursive: true);
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

  /// Writes generated files beside a project and removes its stale outputs.
  Future<void> writeGeneratedFiles(
    String projectPath,
    Map<String, String> files,
  ) async {
    final root = File(projectPath).parent;
    await root.create(recursive: true);
    final manifest = File(
      '${root.path}${Platform.pathSeparator}.flutter_painter_generated.json',
    );
    final oldPaths = await _readManifest(manifest);
    final nextPaths = files.keys.where(_safeRelativePath).toSet();

    for (final entry in files.entries) {
      if (!_safeRelativePath(entry.key)) continue;
      final file = File(_join(root.path, entry.key));
      await file.parent.create(recursive: true);
      await file.writeAsString(entry.value, flush: true);
    }
    for (final path in oldPaths.difference(nextPaths)) {
      final file = File(_join(root.path, path));
      if (file.path == File(projectPath).path || !await file.exists()) continue;
      await file.delete();
      await _removeEmptyParents(file.parent, root);
    }
    await manifest.writeAsString(
      JsonEncoder.withIndent('  ').convert(nextPaths.toList()..sort()),
      flush: true,
    );
  }

  Future<Set<String>> _readManifest(File manifest) async {
    if (!await manifest.exists()) return {};
    try {
      final decoded = jsonDecode(await manifest.readAsString()) as List;
      return {
        for (final path in decoded.whereType<String>())
          if (_safeRelativePath(path)) path,
      };
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  bool _safeRelativePath(String path) {
    final parts = path.replaceAll('\\', '/').split('/');
    return path.isNotEmpty &&
        !path.startsWith('/') &&
        !path.contains(':') &&
        parts.every((part) => part.isNotEmpty && part != '.' && part != '..');
  }

  String _join(String directory, String relative) {
    final base = directory.endsWith(Platform.pathSeparator)
        ? directory.substring(0, directory.length - 1)
        : directory;
    return '$base${Platform.pathSeparator}${relative.replaceAll('/', Platform.pathSeparator)}';
  }

  Future<void> _removeEmptyParents(Directory directory, Directory root) async {
    var current = directory;
    while (current.path != root.path && await current.exists()) {
      if ((await current.list().toList()).isNotEmpty) return;
      await current.delete();
      current = current.parent;
    }
  }
}
