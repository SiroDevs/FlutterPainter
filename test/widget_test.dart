// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/main.dart';

void main() {
  testWidgets('editor opens with tools, layers, background panel and a tab', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const FlutterPainterApp());
    await tester.pump();
    expect(find.text('Layers'), findsOneWidget);
    expect(find.text('Background image'), findsOneWidget);
    expect(find.text('Export Dart'), findsOneWidget);
    expect(find.byTooltip('Rectangle'), findsOneWidget);
    expect(find.text('Untitled'), findsWidgets);
  });

  testWidgets('the + button opens a second project in its own tab', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const FlutterPainterApp());
    await tester.pump();
    await tester.tap(find.byTooltip('New project (Ctrl+N)').last);
    await tester.pump();
    expect(find.text('Untitled 2'), findsWidgets);
    expect(find.byTooltip('Close (Ctrl+W)'), findsNWidgets(2));
  });
}
