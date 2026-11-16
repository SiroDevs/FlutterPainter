import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_painter/data/sources/draft_file_source.dart';
import 'package:flutter_painter/domain/models/drawing/draft.dart';
import 'package:flutter_painter/domain/models/drawing/drawing.dart';
import 'package:flutter_painter/domain/repos/draft_repo.dart';

class _FakeSource extends DraftFileSource {
  _FakeSource({this.writeOk = true, this.stored = const []});

  final bool writeOk;
  final List<String> stored;
  final written = <String, String>{};

  @override
  Future<bool> write(String tabId, String text) async {
    if (writeOk) written[tabId] = text;
    return writeOk;
  }

  @override
  Future<List<String>> readAll() async => stored;
}

Draft _draft(String id, DateTime at) => Draft(
  tabId: id,
  drawing: Drawing(name: id),
  savedAt: at,
);

void main() {
  test('save reports success', () async {
    final source = _FakeSource();
    final ok = await DraftRepo(source).save(_draft('a', DateTime(2026)));
    expect(ok, isTrue);
    expect(source.written.keys, ['a']);
  });

  test('save reports a failed write instead of hiding it', () async {
    final ok = await DraftRepo(
      _FakeSource(writeOk: false),
    ).save(_draft('a', DateTime(2026)));
    expect(ok, isFalse);
  });

  test('pending skips damaged drafts and sorts oldest first', () async {
    final writer = _FakeSource();
    final repo = DraftRepo(writer);
    await repo.save(_draft('new', DateTime(2026, 5)));
    await repo.save(_draft('old', DateTime(2026, 1)));
    final reader = DraftRepo(
      _FakeSource(stored: [...writer.written.values, '{broken', '[]']),
    );
    final drafts = await reader.pending();
    expect(drafts.map((d) => d.tabId), ['old', 'new']);
  });
}
