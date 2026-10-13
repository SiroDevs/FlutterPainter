// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/repos/prefs_repo.dart';

part 'theme_event.dart';

/// The app's light/dark/system mode, remembered between launches.
@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc(this._prefs) : super(_prefs.getThemeMode()) {
    on<ThemeModeChanged>(_onThemeModeChanged);
  }

  final PrefsRepo _prefs;

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeMode> emit,
  ) async {
    await _prefs.updateThemeMode(event.themeMode);
    emit(event.themeMode);
  }
}
