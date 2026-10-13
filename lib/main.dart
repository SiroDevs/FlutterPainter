// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app.dart';
import 'core/di/injectable.dart';

/// Files in [args] open in tabs at launch, which is how an OS file association
/// (double-clicking a .flp) hands a project to the app.
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies('prod');

  runApp(MyApp(initialPaths: args));
}
