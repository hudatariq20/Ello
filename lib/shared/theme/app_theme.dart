import 'package:flutter/material.dart';

import 'app_typography.dart';
import 'persona_theme_model.dart';

abstract final class AppTheme {
  static ThemeData light(PersonaTheme personaTheme) {
    final baseTheme = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: personaTheme.seedColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );

    return baseTheme.copyWith(
      textTheme: AppTypography.textTheme(baseTheme.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: personaTheme.appBarColor,
        foregroundColor: personaTheme.appBarIconColor,
        elevation: 2,
        titleTextStyle:
            AppTypography.textTheme(baseTheme.textTheme).headlineMedium?.copyWith(
                  color: personaTheme.appBarIconColor,
                  fontWeight: FontWeight.w500,
                ),
        iconTheme: IconThemeData(
          color: personaTheme.appBarIconColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: personaTheme.buttonColors.first,
        foregroundColor: Colors.white,
      ),
    );
  }
}