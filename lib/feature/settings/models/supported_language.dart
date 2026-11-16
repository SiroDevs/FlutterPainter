import 'package:flutter/widgets.dart';

/// Describes an app language using its native display name.
class SupportedLanguage {
  const SupportedLanguage(this.locale, this.nativeName);

  final Locale locale;
  final String nativeName;

  static const all = <SupportedLanguage>[
    SupportedLanguage(Locale('ar'), 'العربية'),
    SupportedLanguage(Locale('bn'), 'বাংলা'),
    SupportedLanguage(Locale('de'), 'Deutsch'),
    SupportedLanguage(Locale('en'), 'English'),
    SupportedLanguage(Locale('es'), 'Español'),
    SupportedLanguage(Locale('fa'), 'فارسی'),
    SupportedLanguage(Locale('fr'), 'Français'),
    SupportedLanguage(Locale('gn'), 'Avañe’ẽ'),
    SupportedLanguage(Locale('ha'), 'Hausa'),
    SupportedLanguage(Locale('hi'), 'हिन्दी'),
    SupportedLanguage(Locale('id'), 'Bahasa Indonesia'),
    SupportedLanguage(Locale('ms'), 'Bahasa Melayu'),
    SupportedLanguage(Locale('nl'), 'Nederlands'),
    SupportedLanguage(Locale('pt'), 'Português'),
    SupportedLanguage(Locale('ru'), 'Русский'),
    SupportedLanguage(Locale('sw'), 'Kiswahili'),
    SupportedLanguage(Locale('tr'), 'Türkçe'),
    SupportedLanguage(Locale('ur'), 'اردو'),
    SupportedLanguage(Locale('zh'), '中文（简体）'),
  ];
}
