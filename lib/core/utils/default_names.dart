// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../l10n/gen/app_localizations.dart';

/// The localizations for [languageCode] without needing a [BuildContext];
/// English when the code is not supported.
AppLocalizations appLocalizationsFor(String languageCode) {
  final locale = Locale(languageCode);
  return lookupAppLocalizations(
    AppLocalizations.delegate.isSupported(locale)
        ? locale
        : const Locale('en'),
  );
}

/// Whether [name] is a name the app made up for a new project ("Untitled",
/// "Untitled 2", ...) in any supported language.
///
/// The name is stored in the project, so it can be in a different language
/// from the one currently selected. Numbered names are "<untitled> <number>".
bool isDefaultProjectName(String name) {
  for (final locale in AppLocalizations.supportedLocales) {
    final base = lookupAppLocalizations(locale).untitledProject;
    if (name == base) return true;
    if (name.startsWith('$base ') &&
        int.tryParse(name.substring(base.length + 1)) != null) {
      return true;
    }
  }
  return false;
}
