import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ─── Shared Constants ──────────────────────────────────────────────────────
  static const double kBorderRadius = 30.0; // Pill shape for buttons
  static const double kCardBorderRadius = 16.0;
  static const double kButtonHeight = 56.0;
  static const double kInputHeight = 56.0;

  static ThemeData get light => _baseTheme(Brightness.light);
  static ThemeData get dark => _baseTheme(Brightness.dark);

  static ThemeData _baseTheme(Brightness brightness) {
    // We force a dark-ish theme even in "light" mode as per Sacred Modern rules
    final bg = AppColors.background;
    final surf = AppColors.surface;
    final txt = AppColors.textPrimary;
    final hint = AppColors.textSecondary.withOpacity(0.5);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      primaryColor: AppColors.accent,
      textTheme: _textTheme(txt),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: txt,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.philosopher(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: txt,
        ),
      ),
      cardTheme: CardThemeData(
        color: surf,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCardBorderRadius),
          side: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCardBorderRadius),
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCardBorderRadius),
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCardBorderRadius),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        hintStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: hint,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, kButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          minimumSize: const Size(double.infinity, kButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.primary10,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.accent
                : AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? AppColors.accent
                : AppColors.textSecondary,
          );
        }),
      ),
    );
  }

  static TextTheme _textTheme(Color color) {
    return TextTheme(
      displayLarge: GoogleFonts.philosopher(fontSize: 32, fontWeight: FontWeight.w700, color: color),
      displayMedium: GoogleFonts.philosopher(fontSize: 28, fontWeight: FontWeight.w700, color: color),
      displaySmall: GoogleFonts.philosopher(fontSize: 24, fontWeight: FontWeight.w700, color: color),
      headlineLarge: GoogleFonts.philosopher(fontSize: 24, fontWeight: FontWeight.w700, color: color),
      headlineMedium: GoogleFonts.philosopher(fontSize: 20, fontWeight: FontWeight.w700, color: color),
      headlineSmall: GoogleFonts.philosopher(fontSize: 18, fontWeight: FontWeight.w700, color: color),
      titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: color),
      titleMedium: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: color),
      titleSmall: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: color),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: color),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: color),
      bodySmall: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400, color: color),
      labelLarge: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: color),
    );
  }
}
