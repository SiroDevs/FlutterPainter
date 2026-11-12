// Dart imports:
import 'dart:developer' as developer;

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../data/mappers/draft_mapper.dart';
import '../../data/sources/draft_file_source.dart';
import '../models/drawing/draft.dart';

/// Side copies of projects with unsaved changes.
///
/// A draft is written shortly after each edit and deleted when the project is
/// saved or closed, so anything still on disk at startup is work that was lost
/// to a crash or a forced exit.
@lazySingleton
class DraftRepo {
  DraftRepo(this._source);

  final DraftFileSource _source;

  /// Returns false when the side copy could not be written, so the caller can
  /// warn that the work is not backed up.
  Future<bool> save(Draft draft) =>
      _source.write(draft.tabId, draftToJson(draft));

  Future<void> delete(String tabId) => _source.delete(tabId);

  /// Drafts found on disk, oldest first. Damaged ones are skipped.
  Future<List<Draft>> pending() async {
    final out = <Draft>[];
    for (final text in await _source.readAll()) {
      try {
        out.add(draftFromJson(text));
      } catch (e, st) {
        // Skip a damaged draft rather than blocking the others.
        developer.log(
          'Skipping damaged draft',
          name: 'DraftRepo',
          error: e,
          stackTrace: st,
        );
      }
    }
    out.sort((a, b) => a.savedAt.compareTo(b.savedAt));
    return out;
  }
}
