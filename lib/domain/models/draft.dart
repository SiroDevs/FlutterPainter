// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../core/utils/path_util.dart';
import 'drawing.dart';

part 'draft.freezed.dart';

/// A side copy of a project with unsaved changes, kept so a crash loses nothing.
@freezed
abstract class Draft with _$Draft {
  const Draft._();

  const factory Draft({
    required String tabId,
    required Drawing drawing,
    required DateTime savedAt,

    /// The project file this draft belongs to, if it was ever saved.
    String? path,
  }) = _Draft;

  String get title => path != null ? baseNameOf(path!) : drawing.name;
}
