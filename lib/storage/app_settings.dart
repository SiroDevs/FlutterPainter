// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'support_dir.dart';

/// App-wide settings, kept in settings.json in the support directory.
class AppSettings {
  /// Write changes straight into the open .flp instead of only to a side copy.
  bool autoSave = false;

  Future<File?> _file() async {
    final dir = await supportDir();
    return dir == null ? null : File('${dir.path}/settings.json');
  }

  Future<void> load() async {
    try {
      final f = await _file();
      if (f == null || !await f.exists()) return;
      final j = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      autoSave = (j['autoSave'] as bool?) ?? false;
    } catch (_) {
      // A damaged settings file just means defaults.
    }
  }

  Future<void> save() async {
    try {
      final f = await _file();
      await f?.writeAsString(jsonEncode({'autoSave': autoSave}));
    } catch (_) {
      // Settings are a convenience; never crash over them.
    }
  }
}
