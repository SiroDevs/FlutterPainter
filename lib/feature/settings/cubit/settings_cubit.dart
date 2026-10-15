// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/app_settings.dart';
import '../../../domain/repos/prefs_repo.dart';

/// The user's preferences (everything except the theme), remembered between
/// launches. Changes apply at once.
@lazySingleton
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._prefs) : super(_prefs.getAppSettings());

  final PrefsRepo _prefs;

  void update(AppSettings Function(AppSettings current) change) {
    final next = change(state);
    if (next == state) return;
    _prefs.saveAppSettings(next);
    emit(next);
  }

  void setInterfaceMode(InterfaceMode v) =>
      update((s) => s.copyWith(interfaceMode: v));

  void setCodeStyle(CodeStyle v) => update((s) => s.copyWith(codeStyle: v));

  void setColorPreview(ColorPreview v) =>
      update((s) => s.copyWith(colorPreview: v));

  void setColorFormat(ColorFormat v) =>
      update((s) => s.copyWith(colorFormat: v));

  void setColorConstants(bool v) =>
      update((s) => s.copyWith(colorConstants: v));

  void resetToDefaults() => update((_) => const AppSettings());
}
