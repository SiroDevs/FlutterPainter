// Dart imports:
import 'dart:developer' as developer;
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../common/constants/app_constants.dart';
import 'support_dir.dart';

/// Stores side copies (drafts) as text files in the app's support folder.
/// IO errors never propagate (drafts must not be the thing that crashes the
/// app), but they are logged and [write] reports them to its caller.
@lazySingleton
class DraftFileSource {
  static const _ext = '.${AppConstants.draftExtension}';

  Future<File?> _file(String tabId) async {
    final dir = await supportDir('drafts');
    return dir == null ? null : File('${dir.path}/$tabId$_ext');
  }

  /// Returns false when the draft could not be written.
  Future<bool> write(String tabId, String text) async {
    try {
      final f = await _file(tabId);
      if (f == null) return false;
      final temp = File('${f.path}.tmp');
      await temp.writeAsString(text, flush: true);
      await temp.rename(f.path);
      return true;
    } on Exception catch (e, st) {
      _log('Could not write draft $tabId', e, st);
      return false;
    }
  }

  Future<void> delete(String tabId) async {
    try {
      final f = await _file(tabId);
      if (f != null && await f.exists()) await f.delete();
    } on Exception catch (e, st) {
      _log('Could not delete draft $tabId', e, st);
    }
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
        } on Exception catch (error, st) {
          _log('Could not read draft ${e.path}', error, st);
        }
      }
    } on Exception catch (e, st) {
      _log('Could not list drafts', e, st);
    }
    return out;
  }

  void _log(String message, Object error, StackTrace stackTrace) =>
      developer.log(
        message,
        name: 'DraftFileSource',
        error: error,
        stackTrace: stackTrace,
      );
}
