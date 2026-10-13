// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/feature/workspace/cubit/workspace_cubit.dart';
import 'package:flutter_painter/feature/workspace/workspace_screen.dart';
import 'workspace_cubit_test.dart' show Harness;

void main() {
  testWidgets('the window shows tools, panels and a tab', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    final h = await tester.runAsync(Harness.create) as Harness;
    addTearDown(h.dispose);

    await tester.pumpWidget(
      BlocProvider<WorkspaceCubit>.value(
        value: h.cubit,
        child: const MaterialApp(home: WorkspaceScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Layers'), findsOneWidget);
    expect(find.text('Background image'), findsOneWidget);
    expect(find.text('Export Dart'), findsOneWidget);
    expect(find.byTooltip('Rectangle'), findsOneWidget);
    expect(find.text('Untitled'), findsWidgets);
  });

  testWidgets('the + button opens a second project in its own tab', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    final h = await tester.runAsync(Harness.create) as Harness;
    addTearDown(h.dispose);

    await tester.pumpWidget(
      BlocProvider<WorkspaceCubit>.value(
        value: h.cubit,
        child: const MaterialApp(home: WorkspaceScreen()),
      ),
    );
    await tester.pump();
    await tester.tap(find.byTooltip('New project (Ctrl+N)').last);
    await tester.pump();

    expect(find.text('Untitled 2'), findsWidgets);
    expect(find.byTooltip('Close (Ctrl+W)'), findsNWidgets(2));
  });
}
