// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../feature/export/export_args.dart';
import '../../feature/export/export_screen.dart';
import '../../feature/workspace/workspace_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// [initialPaths] are project or image files to open at launch.
  static GoRouter create({
    String initialLocation = RoutePaths.workspace,
    List<String> initialPaths = const [],
  }) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: kDebugMode,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.workspace,
          name: RouteNames.workspace,
          builder: (context, state) => WorkspaceScreen(initialPaths: initialPaths),
        ),
        // The code editor is a page of its own, pushed over the workspace (which
        // stays alive underneath, so closing the editor returns to the same
        // project). It needs the drawing, passed as `extra`; without one (say a
        // stale link) there is nothing to show, so go back to the workspace.
        GoRoute(
          path: RoutePaths.export,
          name: RouteNames.export,
          redirect: (context, state) =>
              state.extra is ExportArgs ? null : RoutePaths.workspace,
          builder: (context, state) =>
              ExportScreen(args: state.extra! as ExportArgs),
        ),
      ],
      errorBuilder: (context, state) => WorkspaceScreen(initialPaths: initialPaths),
    );
  }
}
