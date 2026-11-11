// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app.dart';
import 'core/di/injectable.dart';
import 'core/platform/window_size_persistence.dart';
import 'domain/repos/prefs_repo.dart';

/// Files in [args] open in tabs at launch, which is how an OS file association
/// (double-clicking a .flp) hands a project to the app.
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies('prod');
  await WindowSizePersistence(getIt<PrefsRepo>()).initialize();

  runApp(MyApp(initialPaths: args));
}
