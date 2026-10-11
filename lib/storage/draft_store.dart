// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import '../editor/editor_controller.dart';
import '../model/drawing.dart';
import 'flp_file.dart';
import 'support_dir.dart';

/// Unsaved work found on disk at startup.
class Draft {
  Draft({
    required this.tabId,
    required this.path,
    required this.drawing,
    required this.savedAt,
  });

  final String tabId;
  final String? path;
  final Drawing drawing;
  final DateTime savedAt;

  String get title => path != null ? baseNameOf(path!) : drawing.name;
}

/// Side copies ("drafts") of projects with unsaved changes. A draft is written
/// shortly after each edit and deleted when the project is saved or closed, so
/// anything still on disk at startup is work that was lost to a crash or exit.
/// Every method swallows IO errors: drafts must never be the thing that fails.
class DraftStore {
  Future<File?> _file(String tabId) async {
    final dir = await supportDir('drafts');
    return dir == null ? null : File('${dir.path}/$tabId.flpdraft');
  }

  Future<void> write(EditorController c) async {
    try {
      final f = await _file(c.tabId);
      if (f == null) return;
      final text = jsonEncode({
        'tabId': c.tabId,
        'path': c.filePath,
        'savedAt': DateTime.now().toIso8601String(),
        'drawing': c.drawing.toJson(),
      });
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

  Future<List<Draft>> pending() async {
    final out = <Draft>[];
    try {
      final dir = await supportDir('drafts');
      if (dir == null) return out;
      await for (final e in dir.list()) {
        if (e is! File || !e.path.endsWith('.flpdraft')) continue;
        try {
          final j = jsonDecode(await e.readAsString()) as Map<String, dynamic>;
          out.add(Draft(
            tabId: j['tabId'] as String,
            path: j['path'] as String?,
            drawing: Drawing.fromJson(j['drawing'] as Map<String, dynamic>),
            savedAt: DateTime.parse(j['savedAt'] as String),
          ));
        } catch (_) {
          // Skip a damaged draft rather than blocking the others.
        }
      }
    } catch (_) {}
    out.sort((a, b) => a.savedAt.compareTo(b.savedAt));
    return out;
  }
}
