// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
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
      ],
      errorBuilder: (context, state) => WorkspaceScreen(initialPaths: initialPaths),
    );
  }
}
