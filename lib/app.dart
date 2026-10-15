// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'common/app_router/app_router.dart';
import 'common/constants/app_constants.dart';
import 'core/di/injectable.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/theme_data.dart';
import 'feature/settings/cubit/settings_cubit.dart';
import 'feature/workspace/cubit/workspace_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialPaths = const []});

  /// Files passed on the command line; they open in tabs at launch.
  final List<String> initialPaths;

  @override
  Widget build(BuildContext context) => AppView(initialPaths: initialPaths);
}

class AppView extends StatefulWidget {
  const AppView({super.key, this.router, this.initialPaths = const []});

  final GoRouter? router;
  final List<String> initialPaths;

  @override
  State<AppView> createState() => AppViewState();
}

class AppViewState extends State<AppView> {
  late final GoRouter _router =
      widget.router ?? AppRouter.create(initialPaths: widget.initialPaths);

  @override
  void dispose() {
    if (widget.router == null) _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ThemeBloc>()),
        BlocProvider.value(value: getIt<WorkspaceCubit>()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          title: AppConstants.appTitle,
          routerConfig: _router,
          themeMode: themeMode,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
