// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get newProject => 'New Project';

  @override
  String get newProjectTooltip => 'Start a new project (Ctrl+N)';

  @override
  String get inlineCode => 'Inline Code';

  @override
  String get inlineCodeTooltip => 'Show or hide the inline code view';

  @override
  String get openFullEditor => 'Open the full code editor';

  @override
  String get undo => 'Undo';

  @override
  String get removeFileTooltip => 'Remove this file and its shapes';

  @override
  String get statusIdle => 'Edit the code and the canvas follows';

  @override
  String get statusRendered => 'Canvas updated from the code';

  @override
  String get statusUnreadable =>
      'Cannot read this code yet; the canvas is unchanged';

  @override
  String statusSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count statements were skipped',
      one: '1 statement was skipped',
    );
    return '$_temp0';
  }

  @override
  String get colorMoreTooltip => 'Open the color picker';

  @override
  String get colorPickerTitle => 'Color picker';

  @override
  String get colorSolid => 'Solid';

  @override
  String get colorGradient => 'Gradient';

  @override
  String get colorWheel => 'Wheel';

  @override
  String get colorSquare => 'Square';

  @override
  String get colorHexCode => 'Hex code';

  @override
  String get colorBrightness => 'Brightness';

  @override
  String get colorOpacity => 'Opacity';

  @override
  String get gradientLinear => 'Linear';

  @override
  String get gradientRadial => 'Radial';

  @override
  String get gradientSweep => 'Sweep';

  @override
  String get gradientAngle => 'Angle';

  @override
  String get gradientRadius => 'Radius';

  @override
  String get gradientAddStop => 'Add stop';

  @override
  String get gradientRemoveStop => 'Remove stop';

  @override
  String get gradientStopPosition => 'Position';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';
}
