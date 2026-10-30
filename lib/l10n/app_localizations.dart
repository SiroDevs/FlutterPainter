import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @newProjectTooltip.
  ///
  /// In en, this message translates to:
  /// **'Start a new project (Ctrl+N)'**
  String get newProjectTooltip;

  /// No description provided for @inlineCode.
  ///
  /// In en, this message translates to:
  /// **'Inline Code'**
  String get inlineCode;

  /// No description provided for @inlineCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show or hide the inline code view'**
  String get inlineCodeTooltip;

  /// No description provided for @openFullEditor.
  ///
  /// In en, this message translates to:
  /// **'Open the full code editor'**
  String get openFullEditor;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @removeFileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove this file and its shapes'**
  String get removeFileTooltip;

  /// No description provided for @statusIdle.
  ///
  /// In en, this message translates to:
  /// **'Edit the code and the canvas follows'**
  String get statusIdle;

  /// No description provided for @statusRendered.
  ///
  /// In en, this message translates to:
  /// **'Canvas updated from the code'**
  String get statusRendered;

  /// No description provided for @statusUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Cannot read this code yet; the canvas is unchanged'**
  String get statusUnreadable;

  /// No description provided for @statusSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 statement was skipped} other{{count} statements were skipped}}'**
  String statusSkipped(int count);

  /// No description provided for @colorMoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open the color picker'**
  String get colorMoreTooltip;

  /// No description provided for @colorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Color picker'**
  String get colorPickerTitle;

  /// No description provided for @colorSolid.
  ///
  /// In en, this message translates to:
  /// **'Solid'**
  String get colorSolid;

  /// No description provided for @colorGradient.
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get colorGradient;

  /// No description provided for @colorWheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get colorWheel;

  /// No description provided for @colorSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get colorSquare;

  /// No description provided for @colorHexCode.
  ///
  /// In en, this message translates to:
  /// **'Hex code'**
  String get colorHexCode;

  /// No description provided for @colorBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get colorBrightness;

  /// No description provided for @colorOpacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get colorOpacity;

  /// No description provided for @gradientLinear.
  ///
  /// In en, this message translates to:
  /// **'Linear'**
  String get gradientLinear;

  /// No description provided for @gradientRadial.
  ///
  /// In en, this message translates to:
  /// **'Radial'**
  String get gradientRadial;

  /// No description provided for @gradientSweep.
  ///
  /// In en, this message translates to:
  /// **'Sweep'**
  String get gradientSweep;

  /// No description provided for @gradientAngle.
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get gradientAngle;

  /// No description provided for @gradientRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get gradientRadius;

  /// No description provided for @gradientAddStop.
  ///
  /// In en, this message translates to:
  /// **'Add stop'**
  String get gradientAddStop;

  /// No description provided for @gradientRemoveStop.
  ///
  /// In en, this message translates to:
  /// **'Remove stop'**
  String get gradientRemoveStop;

  /// No description provided for @gradientStopPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get gradientStopPosition;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
