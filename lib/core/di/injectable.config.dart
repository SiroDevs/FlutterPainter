// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_painter/core/di/injectable.dart' as _i135;
import 'package:flutter_painter/core/platform/file_dialogs.dart' as _i985;
import 'package:flutter_painter/core/theme/bloc/theme_bloc.dart' as _i109;
import 'package:flutter_painter/data/sources/draft_file_source.dart' as _i691;
import 'package:flutter_painter/data/sources/project_file_source.dart' as _i85;
import 'package:flutter_painter/domain/repos/draft_repo.dart' as _i760;
import 'package:flutter_painter/domain/repos/prefs_repo.dart' as _i415;
import 'package:flutter_painter/domain/repos/project_repo.dart' as _i741;
import 'package:flutter_painter/feature/editor/bloc/editor_bloc.dart' as _i1017;
import 'package:flutter_painter/feature/editor/bloc/editor_bloc_factory.dart'
    as _i133;
import 'package:flutter_painter/feature/editor/models/editor_seed.dart'
    as _i594;
import 'package:flutter_painter/feature/export/cubit/export_cubit.dart'
    as _i146;
import 'package:flutter_painter/feature/workspace/cubit/project_saver.dart'
    as _i1028;
import 'package:flutter_painter/feature/workspace/cubit/workspace_cubit.dart'
    as _i753;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPrefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i985.FileDialogs>(() => _i985.FileDialogs());
    gh.lazySingleton<_i691.DraftFileSource>(() => _i691.DraftFileSource());
    gh.lazySingleton<_i85.ProjectFileSource>(() => _i85.ProjectFileSource());
    gh.lazySingleton<_i133.EditorBlocFactory>(() => _i133.EditorBlocFactory());
    gh.factoryParam<_i1017.EditorBloc, _i594.EditorSeed, dynamic>(
      (seed, _) => _i1017.EditorBloc(seed),
    );
    gh.singleton<_i415.PrefsRepo>(
      () => _i415.PrefsRepo(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i741.ProjectRepo>(
      () => _i741.ProjectRepo(gh<_i85.ProjectFileSource>()),
    );
    gh.factory<_i146.ExportCubit>(
      () => _i146.ExportCubit(gh<_i985.FileDialogs>()),
    );
    gh.lazySingleton<_i760.DraftRepo>(
      () => _i760.DraftRepo(gh<_i691.DraftFileSource>()),
    );
    gh.lazySingleton<_i109.ThemeBloc>(
      () => _i109.ThemeBloc(gh<_i415.PrefsRepo>()),
    );
    gh.lazySingleton<_i1028.ProjectSaver>(
      () => _i1028.ProjectSaver(gh<_i741.ProjectRepo>(), gh<_i760.DraftRepo>()),
    );
    gh.lazySingleton<_i753.WorkspaceCubit>(
      () => _i753.WorkspaceCubit(
        gh<_i741.ProjectRepo>(),
        gh<_i760.DraftRepo>(),
        gh<_i1028.ProjectSaver>(),
        gh<_i415.PrefsRepo>(),
        gh<_i133.EditorBlocFactory>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i135.RegisterModule {}
