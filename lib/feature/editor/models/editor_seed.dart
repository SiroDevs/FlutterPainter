// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../../domain/models/drawing.dart';

part 'editor_seed.freezed.dart';

/// What a new editor (one tab) starts from. Passed to the bloc as its
/// injectable factory parameter.
@freezed
abstract class EditorSeed with _$EditorSeed {
  const factory EditorSeed({
    required String tabId,
    required Drawing drawing,

    /// The .flp this project is saved to, if any.
    String? filePath,

    /// True for a recovered draft: nothing here matches the file on disk.
    @Default(false) bool recovered,
  }) = _EditorSeed;
}
