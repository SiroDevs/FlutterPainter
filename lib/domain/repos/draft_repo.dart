// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../data/mappers/draft_mapper.dart';
import '../../data/sources/draft_file_source.dart';
import '../models/draft.dart';

/// Side copies of projects with unsaved changes.
///
/// A draft is written shortly after each edit and deleted when the project is
/// saved or closed, so anything still on disk at startup is work that was lost
/// to a crash or a forced exit.
@lazySingleton
class DraftRepo {
  DraftRepo(this._source);

  final DraftFileSource _source;

  Future<void> save(Draft draft) =>
      _source.write(draft.tabId, draftToJson(draft));

  Future<void> delete(String tabId) => _source.delete(tabId);

  /// Drafts found on disk, oldest first. Damaged ones are skipped.
  Future<List<Draft>> pending() async {
    final out = <Draft>[];
    for (final text in await _source.readAll()) {
      try {
        out.add(draftFromJson(text));
      } catch (_) {
        // Skip a damaged draft rather than blocking the others.
      }
    }
    out.sort((a, b) => a.savedAt.compareTo(b.savedAt));
    return out;
  }
}
