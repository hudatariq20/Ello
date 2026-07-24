import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextTheme textTheme(TextTheme base) {
    return GoogleFonts.urbanistTextTheme(base).copyWith(
      displayLarge: GoogleFonts.urbanist(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
      headlineLarge: GoogleFonts.urbanist(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      headlineMedium: GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      headlineSmall: GoogleFonts.urbanist(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleLarge: GoogleFonts.urbanist(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.urbanist(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.urbanist(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyMedium: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      labelMedium: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}