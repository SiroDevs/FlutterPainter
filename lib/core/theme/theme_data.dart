// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'theme_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: ThemeColors.panelLight,
      );

  static ThemeData darkTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: ThemeColors.panelDark,
      );
}
