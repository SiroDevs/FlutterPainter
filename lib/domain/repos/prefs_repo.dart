// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import '../../common/constants/pref_constants.dart';
import '../models/app_settings.dart';

@singleton
abstract class PrefsRepo {
  @factoryMethod
  factory PrefsRepo(SharedPreferences prefsRepository) = PrefsRepoImp;

  ThemeMode getThemeMode();

  Future<void> updateThemeMode(ThemeMode themeMode);

  /// The saved preferences (interface, export and colour options), with the
  /// defaults for anything not saved yet.
  AppSettings getAppSettings();

  void saveAppSettings(AppSettings settings);

  bool getPrefBool(String settingsKey);
  int getPrefInt(String settingsKey);
  String getPrefString(String settingsKey);

  void setPrefBool(String settingsKey, bool settingsValue);
  void setPrefInt(String settingsKey, int settingsValue);
  void setPrefString(String settingsKey, String settingsValue);

  void clearData();
  void removeKeyPair(String settingsKey);
  bool keyExists(String settingsKey);
}

class PrefsRepoImp implements PrefsRepo {
  final SharedPreferences sharedPrefs;

  PrefsRepoImp(this.sharedPrefs);

  @override
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await sharedPrefs.setString(
      PrefConstants.appThemeKey,
      themeMode.toString(),
    );
  }

  @override
  ThemeMode getThemeMode() {
    switch (sharedPrefs.getString(PrefConstants.appThemeKey)) {
      case 'ThemeMode.light':
        return ThemeMode.light;

      case 'ThemeMode.dark':
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  /// The enum value saved under [key] by name, or [fallback].
  T _enum<T extends Enum>(List<T> values, String key, T fallback) {
    final saved = sharedPrefs.getString(key);
    for (final v in values) {
      if (v.name == saved) return v;
    }
    return fallback;
  }

  @override
  AppSettings getAppSettings() {
    const defaults = AppSettings();
    return AppSettings(
      interfaceMode: _enum(
        InterfaceMode.values,
        PrefConstants.interfaceModeKey,
        defaults.interfaceMode,
      ),
      codeStyle: _enum(
        CodeStyle.values,
        PrefConstants.codeStyleKey,
        defaults.codeStyle,
      ),
      colorPreview: _enum(
        ColorPreview.values,
        PrefConstants.colorPreviewKey,
        defaults.colorPreview,
      ),
      colorFormat: _enum(
        ColorFormat.values,
        PrefConstants.colorFormatKey,
        defaults.colorFormat,
      ),
      // Stored as text because "false" must stay distinguishable from "never
      // saved", which defaults to true.
      colorConstants: sharedPrefs.getString(PrefConstants.colorConstantsKey) !=
          'false',
    );
  }

  @override
  void saveAppSettings(AppSettings settings) {
    sharedPrefs.setString(
      PrefConstants.interfaceModeKey,
      settings.interfaceMode.name,
    );
    sharedPrefs.setString(PrefConstants.codeStyleKey, settings.codeStyle.name);
    sharedPrefs.setString(
      PrefConstants.colorPreviewKey,
      settings.colorPreview.name,
    );
    sharedPrefs.setString(
      PrefConstants.colorFormatKey,
      settings.colorFormat.name,
    );
    sharedPrefs.setString(
      PrefConstants.colorConstantsKey,
      settings.colorConstants.toString(),
    );
  }

  @override
  void clearData() {
    sharedPrefs.remove(PrefConstants.appThemeKey);
    sharedPrefs.remove(PrefConstants.autoSaveKey);
    sharedPrefs.remove(PrefConstants.interfaceModeKey);
    sharedPrefs.remove(PrefConstants.codeStyleKey);
    sharedPrefs.remove(PrefConstants.colorPreviewKey);
    sharedPrefs.remove(PrefConstants.colorFormatKey);
    sharedPrefs.remove(PrefConstants.colorConstantsKey);
  }

  @override
  void removeKeyPair(String key) {
    sharedPrefs.remove(key);
  }

  @override
  bool keyExists(String key) {
    return sharedPrefs.containsKey(key);
  }

  @override
  bool getPrefBool(String settingsKey) {
    return sharedPrefs.getBool(settingsKey) ?? false;
  }

  @override
  int getPrefInt(String settingsKey) {
    return sharedPrefs.getInt(settingsKey) ?? 0;
  }

  @override
  String getPrefString(String settingsKey) {
    return sharedPrefs.getString(settingsKey) ?? '';
  }

  @override
  void setPrefBool(String settingsKey, bool settingsValue) async {
    if (!settingsValue) {
      sharedPrefs.remove(settingsKey);
      return;
    }
    await sharedPrefs.setBool(settingsKey, settingsValue);
  }

  @override
  void setPrefInt(String settingsKey, int settingsValue) async {
    if (settingsValue.isNegative) {
      sharedPrefs.remove(settingsKey);
      return;
    }
    await sharedPrefs.setInt(settingsKey, settingsValue);
  }

  @override
  void setPrefString(String settingsKey, String settingsValue) async {
    if (settingsValue.isEmpty) {
      sharedPrefs.remove(settingsKey);
      return;
    }
    await sharedPrefs.setString(settingsKey, settingsValue);
  }
}
