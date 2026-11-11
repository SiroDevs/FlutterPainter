import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_painter/domain/models/drawing/drawing.dart';
import 'package:flutter_painter/domain/models/drawing/edit_history.dart';

Drawing _d(String name) => Drawing(name: name);

void main() {
  group('EditHistory', () {
    test('starts clean and cannot undo/redo', () {
      final h = EditHistory.initial(_d('a'));
      expect(h.canUndo, isFalse);
      expect(h.canRedo, isFalse);
      expect(h.isAtSaved, isTrue);
    });

    test('recovered drafts start unsaved', () {
      final h = EditHistory.initial(_d('a'), saved: false);
      expect(h.isAtSaved, isFalse);
    });

    test('push of an equal drawing returns the same history', () {
      final h = EditHistory.initial(_d('a'));
      expect(identical(h.push(_d('a')), h), isTrue);
    });

    test('push, undo and redo move through snapshots', () {
      var h = EditHistory.initial(_d('a')).push(_d('b')).push(_d('c'));
      expect(h.current.name, 'c');
      h = h.undo()!;
      expect(h.current.name, 'b');
      h = h.redo()!;
      expect(h.current.name, 'c');
      expect(h.redo(), isNull);
    });

    test('push after undo drops the redo branch', () {
      var h = EditHistory.initial(_d('a')).push(_d('b')).push(_d('c'));
      h = h.undo()!.push(_d('x'));
      expect(h.canRedo, isFalse);
      expect(h.current.name, 'x');
      expect(h.states.length, 3);
    });

    test('undoing back to the saved snapshot is clean again', () {
      var h = EditHistory.initial(_d('a')).push(_d('b'));
      expect(h.isAtSaved, isFalse);
      h = h.undo()!;
      expect(h.isAtSaved, isTrue);
    });

    test('markSaved / markUnsaved', () {
      var h = EditHistory.initial(_d('a')).push(_d('b')).markSaved();
      expect(h.isAtSaved, isTrue);
      h = h.markUnsaved();
      expect(h.isAtSaved, isFalse);
    });

    test('saved snapshot is forgotten when its redo branch is discarded', () {
      var h = EditHistory.initial(_d('a')).push(_d('b')).markSaved();
      h = h.undo()!.push(_d('c'));
      expect(h.savedIndex, -1);
      expect(h.isAtSaved, isFalse);
    });

    test('history is capped at maxStates and savedIndex shifts with it', () {
      var h = EditHistory.initial(_d('0'));
      for (var i = 1; i <= EditHistory.maxStates + 10; i++) {
        h = h.push(_d('$i'));
      }
      expect(h.states.length, EditHistory.maxStates);
      expect(h.current.name, '${EditHistory.maxStates + 10}');
      // The initial saved snapshot fell off the front.
      expect(h.isAtSaved, isFalse);
      expect(h.index, h.states.length - 1);
    });
  });
}
