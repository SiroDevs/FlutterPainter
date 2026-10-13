// Dart imports:
import 'dart:io';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:flutter_painter/data/sources/draft_file_source.dart';
import 'package:flutter_painter/data/sources/project_file_source.dart';
import 'package:flutter_painter/domain/models/draft.dart';
import 'package:flutter_painter/domain/models/drawing.dart';
import 'package:flutter_painter/domain/models/tool.dart';
import 'package:flutter_painter/domain/repos/draft_repo.dart';
import 'package:flutter_painter/domain/repos/prefs_repo.dart';
import 'package:flutter_painter/domain/repos/project_repo.dart';
import 'package:flutter_painter/feature/editor/bloc/editor_bloc.dart';
import 'package:flutter_painter/feature/editor/bloc/editor_bloc_factory.dart';
import 'package:flutter_painter/feature/editor/logic/editor_ops.dart';
import 'package:flutter_painter/feature/editor/models/editor_seed.dart';
import 'package:flutter_painter/feature/workspace/cubit/project_saver.dart';
import 'package:flutter_painter/feature/workspace/cubit/workspace_cubit.dart';

/// Keeps drafts in memory instead of the real support folder.
class MemoryDrafts extends DraftFileSource {
  final Map<String, String> files = {};

  @override
  Future<void> write(String tabId, String text) async => files[tabId] = text;

  @override
  Future<void> delete(String tabId) async => files.remove(tabId);

  @override
  Future<List<String>> readAll() async => files.values.toList();
}

class TestBlocFactory extends EditorBlocFactory {
  @override
  EditorBloc create(EditorSeed seed) => EditorBloc(seed);
}

/// Everything a workspace test needs, wired with fakes where the platform would
/// otherwise be involved.
class Harness {
  Harness(this.cubit, this.drafts, this.projects, this.dir);

  final WorkspaceCubit cubit;
  final MemoryDrafts drafts;
  final ProjectRepo projects;
  final Directory dir;

  static Future<Harness> create() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = PrefsRepo(await SharedPreferences.getInstance());
    final drafts = MemoryDrafts();
    final draftRepo = DraftRepo(drafts);
    final projects = ProjectRepo(ProjectFileSource());
    final cubit = WorkspaceCubit(
      projects,
      draftRepo,
      ProjectSaver(projects, draftRepo),
      prefs,
      TestBlocFactory(),
    )..init();
    return Harness(cubit, drafts, projects, Directory.systemTemp.createTempSync('flp_ws'));
  }

  String path(String name) => '${dir.path}/$name';

  Future<void> dispose() async {
    await cubit.close();
    dir.deleteSync(recursive: true);
  }
}

/// Draws a rectangle in [bloc] and waits for it to be handled.
Future<void> drawRect(EditorBloc bloc) async {
  bloc
    ..add(const EditorEvent.toolSelected(Tool.rect))
    ..add(const EditorEvent.pointerPressed(Offset(0, 0)))
    ..add(const EditorEvent.pointerMoved(Offset(8, 8)))
    ..add(const EditorEvent.pointerReleased());
  await pumpEventQueue();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Harness h;
  setUp(() async => h = await Harness.create());
  tearDown(() => h.dispose());

  test('starts with one blank tab; new ones are numbered', () {
    expect(h.cubit.state.tabs.single.title, 'Untitled');
    h.cubit.addBlank();
    expect(h.cubit.state.tabs.map((t) => t.title), ['Untitled', 'Untitled 2']);
    expect(h.cubit.state.active, 1);
  });

  test('unsaved edits go to a side copy, not to the file', () async {
    final bloc = h.cubit.current;
    await h.cubit.commitSave(bloc, h.path('art.flp'));
    await drawRect(bloc);
    await h.cubit.persist(bloc);

    expect(h.drafts.files, contains(bloc.state.tabId));
    final onDisk = await h.projects.open(h.path('art.flp'));
    expect(onDisk.hasShapes, isFalse, reason: 'the real file is untouched until Save');
    expect(h.cubit.state.tabs.single.dirty, isTrue);
  });

  test('save writes the file, marks the tab clean and removes the side copy', () async {
    final bloc = h.cubit.current;
    await drawRect(bloc);
    await h.cubit.persist(bloc);
    expect(h.drafts.files, isNotEmpty);

    await h.cubit.commitSave(bloc, h.path('rider.flp'), name: 'rider');

    expect(bloc.state.dirty, isFalse);
    expect(bloc.state.filePath, h.path('rider.flp'));
    expect(bloc.state.drawing.name, 'rider');
    expect(h.drafts.files, isEmpty);
    expect((await h.projects.open(h.path('rider.flp'))).layers.first.shapes.length, 1);
    expect(File('${h.path('rider.flp')}.tmp').existsSync(), isFalse,
        reason: 'the atomic write leaves no temp file');
    expect(h.cubit.state.tabs.single.title, 'rider');
    expect(h.cubit.state.tabs.single.dirty, isFalse);
  });

  test('auto-save writes straight into a confirmed file', () async {
    final bloc = h.cubit.current;
    await h.cubit.commitSave(bloc, h.path('auto.flp'));
    await h.cubit.setAutoSave(true);
    expect(h.cubit.state.autoSave, isTrue);

    await drawRect(bloc);
    await h.cubit.persist(bloc);

    expect(bloc.state.dirty, isFalse);
    expect((await h.projects.open(h.path('auto.flp'))).layers.first.shapes.length, 1);
    expect(h.drafts.files, isEmpty);
  });

  test('auto-save keeps to the side copy until an opened file is confirmed', () async {
    await h.projects.save(h.path('opened.flp'), const Drawing(name: 'opened'));
    await h.cubit.openProject(h.path('opened.flp'));
    final bloc = h.cubit.current;
    await h.cubit.setAutoSave(true);

    await drawRect(bloc);
    await h.cubit.persist(bloc);

    expect(bloc.state.dirty, isTrue);
    expect(h.drafts.files, contains(bloc.state.tabId));
    expect((await h.projects.open(h.path('opened.flp'))).hasShapes, isFalse);
  });

  test('opening the same file twice shows the existing tab', () async {
    await h.projects.save(h.path('a.flp'), const Drawing(name: 'a'));
    await h.cubit.openProject(h.path('a.flp'));
    final count = h.cubit.editors.length;
    await h.cubit.openProject(h.path('a.flp'));
    expect(h.cubit.editors.length, count);
  });

  test('closing a tab keeps the right tab active', () async {
    final a = h.cubit.current;
    final b = h.cubit.addBlank();
    final c = h.cubit.addBlank();
    h.cubit.activate(2);
    await h.cubit.removeTab(a);
    expect(h.cubit.current, c);
    await h.cubit.removeTab(c);
    expect(h.cubit.current, b);
  });

  test('closing the last tab leaves a fresh blank one', () async {
    final only = h.cubit.current;
    await h.cubit.removeTab(only);
    expect(h.cubit.editors.length, 1);
    expect(identical(h.cubit.current, only), isFalse);
  });

  test('closing a tab discards its side copy', () async {
    final extra = h.cubit.addBlank();
    await drawRect(extra);
    await h.cubit.persist(extra);
    expect(h.drafts.files, contains(extra.state.tabId));
    await h.cubit.removeTab(extra);
    expect(h.drafts.files, isEmpty);
  });

  test('side copies can be found again and restored as unsaved tabs', () async {
    final bloc = h.cubit.addBlank();
    await drawRect(bloc);
    await h.cubit.persist(bloc);

    final pending = await h.cubit.pendingDrafts();
    expect(pending.single.tabId, bloc.state.tabId);

    final restored = h.cubit.restore(Draft(
      tabId: 'recovered-1',
      path: h.path('lost.flp'),
      drawing: pending.single.drawing,
      savedAt: DateTime.now(),
    ));
    expect(restored.state.dirty, isTrue);
    expect(restored.state.filePath, h.path('lost.flp'));
    expect(restored.state.overwriteConfirmed, isFalse);
  });

  test('a blank tab is pristine, an edited one is not', () async {
    expect(h.cubit.current.state.isPristine, isTrue);
    await drawRect(h.cubit.current);
    expect(h.cubit.current.state.isPristine, isFalse);
  });

  test('dropping the pristine first tab when other projects opened', () async {
    await h.projects.save(h.path('b.flp'), const Drawing(name: 'b'));
    await h.cubit.openProject(h.path('b.flp'));
    expect(h.cubit.editors.length, 2);
    h.cubit.dropPristineFirstTab();
    await pumpEventQueue();
    expect(h.cubit.editors.length, 1);
    expect(h.cubit.current.state.drawing.name, 'b');
  });
}
