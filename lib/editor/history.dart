/// Undo/redo as a stack of whole-document snapshots (JSON strings), plus a
/// marker for which snapshot matches what is on disk. That marker is what makes
/// "unsaved changes" exact: undoing back to the saved state is clean again.
class History {
  final List<String> _states = [];
  int _index = -1;
  int _savedIndex = 0;

  bool get canUndo => _index > 0;
  bool get canRedo => _index >= 0 && _index < _states.length - 1;
  bool get isAtSaved => _index == _savedIndex;

  void reset(String state) {
    _states
      ..clear()
      ..add(state);
    _index = 0;
    _savedIndex = 0;
  }

  void markSaved() => _savedIndex = _index;

  /// For recovered drafts: nothing in this history matches the file on disk.
  void markUnsaved() => _savedIndex = -1;

  /// Returns false (and records nothing) if [state] equals the current one.
  bool push(String state) {
    if (_index >= 0 && _states[_index] == state) return false;
    _states.removeRange(_index + 1, _states.length);
    if (_savedIndex > _index) _savedIndex = -1;
    _states.add(state);
    _index++;
    if (_states.length > 200) {
      _states.removeAt(0);
      _index--;
      if (_savedIndex >= 0) _savedIndex--;
    }
    return true;
  }

  String? undo() => canUndo ? _states[--_index] : null;
  String? redo() => canRedo ? _states[++_index] : null;
}
