// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/di/injectable.dart';
import '../models/editor_seed.dart';
import 'editor_bloc.dart';

/// Creates one [EditorBloc] per open project. The workspace asks this factory
/// instead of reaching into the service locator itself, so tests can hand it a
/// fake that builds blocs directly.
@lazySingleton
class EditorBlocFactory {
  EditorBloc create(EditorSeed seed) => getIt<EditorBloc>(param1: seed);
}
