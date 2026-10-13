// Dart imports:
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../common/constants/app_constants.dart';
import 'support_dir.dart';

/// Stores side copies (drafts) as text files in the app's support folder.
/// Every method swallows IO errors: drafts must never be the thing that fails.
@lazySingleton
class DraftFileSource {
  static const _ext = '.${AppConstants.draftExtension}';

  Future<File?> _file(String tabId) async {
    final dir = await supportDir('drafts');
    return dir == null ? null : File('${dir.path}/$tabId$_ext');
  }

  Future<void> write(String tabId, String text) async {
    try {
      final f = await _file(tabId);
      if (f == null) return;
      final temp = File('${f.path}.tmp');
      await temp.writeAsString(text, flush: true);
      await temp.rename(f.path);
    } catch (_) {}
  }

  Future<void> delete(String tabId) async {
    try {
      final f = await _file(tabId);
      if (f != null && await f.exists()) await f.delete();
    } catch (_) {}
  }

  /// The text of every draft found on disk.
  Future<List<String>> readAll() async {
    final out = <String>[];
    try {
      final dir = await supportDir('drafts');
      if (dir == null) return out;
      await for (final e in dir.list()) {
        if (e is! File || !e.path.endsWith(_ext)) continue;
        try {
          out.add(await e.readAsString());
        } catch (_) {}
      }
    } catch (_) {}
    return out;
  }
}
