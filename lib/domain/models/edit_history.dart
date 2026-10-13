// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'drawing.dart';

part 'edit_history.freezed.dart';

/// Undo/redo as a list of whole-document snapshots. Drawings are immutable, so
/// snapshots share structure and cost almost nothing. [savedIndex] marks the
/// snapshot that matches the file on disk, which makes "unsaved changes" exact:
/// undoing back to the saved state is clean again.
@freezed
abstract class EditHistory with _$EditHistory {
  const EditHistory._();

  const factory EditHistory({
    required List<Drawing> states,
    required int index,
    required int savedIndex,
  }) = _EditHistory;

  /// [saved] false is for recovered drafts: nothing here matches the disk.
  factory EditHistory.initial(Drawing drawing, {bool saved = true}) =>
      EditHistory(states: [drawing], index: 0, savedIndex: saved ? 0 : -1);

  static const maxStates = 200;

  Drawing get current => states[index];
  bool get canUndo => index > 0;
  bool get canRedo => index < states.length - 1;
  bool get isAtSaved => index == savedIndex;

  /// Records [drawing] as the new current state. Returns this history unchanged
  /// if it equals the current one.
  EditHistory push(Drawing drawing) {
    if (states[index] == drawing) return this;
    var next = [...states.sublist(0, index + 1), drawing];
    var idx = index + 1;
    var saved = savedIndex > index ? -1 : savedIndex;
    if (next.length > maxStates) {
      next = next.sublist(1);
      idx--;
      if (saved >= 0) saved--;
    }
    return EditHistory(states: next, index: idx, savedIndex: saved);
  }

  EditHistory? undo() => canUndo ? copyWith(index: index - 1) : null;
  EditHistory? redo() => canRedo ? copyWith(index: index + 1) : null;

  EditHistory markSaved() => copyWith(savedIndex: index);
  EditHistory markUnsaved() => copyWith(savedIndex: -1);
}
