// Dart imports:
import 'dart:io';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/editor/draw_ops.dart';
import 'package:flutter_painter/editor/editor_controller.dart';
import 'package:flutter_painter/model/shape.dart';
import 'package:flutter_painter/storage/draft_store.dart';
import 'package:flutter_painter/storage/flp_file.dart';
import 'package:flutter_painter/workspace/workspace.dart';

/// Records draft traffic instead of touching the real support directory.
class _FakeDrafts extends DraftStore {
  final Set<String> written = {};

  @override
  Future<void> write(EditorController c) async => written.add(c.tabId);

  @override
  Future<void> delete(String tabId) async => written.remove(tabId);

  @override
  Future<List<Draft>> pending() async => const [];
}

void _draw(EditorController c) {
  c.draft = c.newShape(ShapeKind.rect, [const Offset(0, 0), const Offset(8, 8)]);
  c.commitDraft();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late _FakeDrafts drafts;
  late Workspace ws;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('flp_test');
    drafts = _FakeDrafts();
    ws = Workspace(drafts: drafts);
  });

  tearDown(() => dir.deleteSync(recursive: true));

  test('untitled tabs are numbered', () {
    expect(ws.addBlank().drawing.name, 'Untitled');
    expect(ws.addBlank().drawing.name, 'Untitled 2');
    expect(ws.tabs.length, 2);
  });

  test('unsaved edits go to a side copy, not to the file', () async {
    final path = '${dir.path}/art.flp';
    final c = ws.addBlank();
    await ws.commitSave(c, path);
    _draw(c);
    await ws.persist(c);
    expect(drafts.written, contains(c.tabId));
    expect((await readFlp(path)).layers.first.shapes, isEmpty,
        reason: 'the real file is untouched until Save');
  });

  test('save writes the file, marks the tab clean and removes the side copy', () async {
    final path = '${dir.path}/art.flp';
    final c = ws.addBlank();
    _draw(c);
    await ws.persist(c);
    expect(drafts.written, contains(c.tabId));

    await ws.commitSave(c, path);

    expect(c.dirty, isFalse);
    expect(c.filePath, path);
    expect(drafts.written, isNot(contains(c.tabId)));
    expect((await readFlp(path)).layers.first.shapes.length, 1);
    expect(File('$path.tmp').existsSync(), isFalse, reason: 'atomic write leaves no temp file');
  });

  test('auto-save writes straight into a confirmed file', () async {
    final path = '${dir.path}/auto.flp';
    final c = ws.addBlank();
    await ws.commitSave(c, path);
    ws.settings.autoSave = true;

    _draw(c);
    await ws.persist(c);

    expect(c.dirty, isFalse);
    expect((await readFlp(path)).layers.first.shapes.length, 1);
    expect(drafts.written, isEmpty);
  });

  test('auto-save keeps to the side copy until an opened file is confirmed', () async {
    final path = '${dir.path}/opened.flp';
    await ws.commitSave(ws.addBlank(), path);
    final opened = ws.addTab(EditorController(
      drawing: await readFlp(path),
      filePath: path,
    ));
    ws.settings.autoSave = true;

    _draw(opened);
    await ws.persist(opened);

    expect(opened.dirty, isTrue);
    expect(drafts.written, contains(opened.tabId));
    expect((await readFlp(path)).layers.first.shapes, isEmpty);
  });

  test('closing the last tab leaves a fresh blank one', () async {
    final only = ws.addBlank();
    await ws.removeTab(only);
    expect(ws.tabs.length, 1);
    expect(identical(ws.tabs.first, only), isFalse);
  });

  test('closing a tab keeps the right tab active', () async {
    final a = ws.addBlank();
    final b = ws.addBlank();
    final c = ws.addBlank();
    ws.activate(2);
    await ws.removeTab(a);
    expect(ws.current, c);
    await ws.removeTab(c);
    expect(ws.current, b);
  });

  test('flp helpers', () {
    expect(baseNameOf(r'C:\art\rider.flp'), 'rider');
    expect(baseNameOf('/home/me/bike.v2.flp'), 'bike.v2');
    expect(isProjectFile('x.FLP'), isTrue);
    expect(isImageFile('trace.PNG'), isTrue);
    expect(isProjectFile('x.png'), isFalse);
  });
}
