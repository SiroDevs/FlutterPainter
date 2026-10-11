// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'ui/painter_page.dart';

/// Files in [args] open in tabs at launch, which is how an OS file association
/// (double-clicking a .flp) hands a project to the app.
void main(List<String> args) => runApp(FlutterPainterApp(initialPaths: args));

class FlutterPainterApp extends StatelessWidget {
  const FlutterPainterApp({super.key, this.initialPaths = const []});

  final List<String> initialPaths;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Painter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: PainterPage(initialPaths: initialPaths),
    );
  }
}
