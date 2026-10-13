// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/domain/models/drawing.dart';
import 'package:flutter_painter/domain/models/edit_history.dart';

Drawing _d(String name) => Drawing(name: name);

void main() {
  test('tracks which state matches the saved one', () {
    var h = EditHistory.initial(_d('a'));
    expect(h.isAtSaved, isTrue);
    h = h.push(_d('b'));
    expect(h.isAtSaved, isFalse);
    h = h.markSaved();
    expect(h.isAtSaved, isTrue);
    h = h.push(_d('c'));
    expect(h.isAtSaved, isFalse);
    h = h.undo()!;
    expect(h.isAtSaved, isTrue, reason: 'undoing back to the saved state is clean');
  });

  test('a recovered draft is never at the saved state', () {
    expect(EditHistory.initial(_d('a'), saved: false).isAtSaved, isFalse);
  });

  test('pushing after undo drops the redo branch and the saved marker with it', () {
    var h = EditHistory.initial(_d('a')).push(_d('b')).markSaved();
    h = h.undo()!.push(_d('c'));
    expect(h.canRedo, isFalse);
    expect(h.isAtSaved, isFalse);
  });

  test('pushing an identical state returns the same history', () {
    final h = EditHistory.initial(_d('a'));
    expect(identical(h.push(_d('a')), h), isTrue);
  });

  test('undo and redo walk the snapshots', () {
    var h = EditHistory.initial(_d('a')).push(_d('b')).push(_d('c'));
    expect(h.current.name, 'c');
    h = h.undo()!;
    expect(h.current.name, 'b');
    h = h.redo()!;
    expect(h.current.name, 'c');
    expect(h.redo(), isNull);
  });

  test('history is capped', () {
    var h = EditHistory.initial(_d('0'));
    for (var i = 1; i <= EditHistory.maxStates + 20; i++) {
      h = h.push(_d('$i'));
    }
    expect(h.states.length, EditHistory.maxStates);
    expect(h.current.name, '${EditHistory.maxStates + 20}');
  });
}
