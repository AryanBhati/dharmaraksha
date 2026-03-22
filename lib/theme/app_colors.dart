import 'package:flutter/material.dart';

/// Hardline monochromatic palette — Deep Trust Blue + Spiritual Gold.
///
/// Every colour decision must pass through this file.
/// Only blue, off-white, gold, and two semantic colours are allowed.
class AppColors {
  AppColors._();

  // ─── Core Palette (Sacred Modern) ──────────────────────────────────────────
  static const Color background = Color(0xFF0D0D1A);      // Deep Midnight
  static const Color surface = Color(0xFF1A1A2E);         // Deep Purple Surface
  static const Color accent = Color(0xFFFF6B35);          // Saffron Accent
  static const Color gold = Color(0xFFFFD700);            // Gold
  static const Color primary = accent;

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF);   // 70% White
  static const Color textTertiary = Color(0x80FFFFFF);    // 50% White

  // ─── Functional ────────────────────────────────────────────────────────────
  static const Color border = Color(0x1AFFFFFF);          // 10% White
  static const Color divider = border;
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFB74D);

  // ─── Glassmorphism Helpers ─────────────────────────────────────────────────
  static Color get glassColor => Colors.white.withOpacity(0.05);
  static Color get glassBorder => Colors.white.withOpacity(0.1);

  // ─── Legacy Compat & Aliases ───────────────────────────────────────────────
  static const Color primaryDark = Color(0xFF0A0A16);
  static const Color surfaceVariant = Color(0xFF252545);
  static const Color secondary = Color(0xFF3D3D5C);
  
  static const Color surfaceDark = surface;
  static const Color borderDark = border;
  static const Color backgroundDark = background;
  static const Color textPrimaryDark = textPrimary;
  static const Color textSecondaryDark = textSecondary;
  static const Color primaryDarkTheme = accent;

  static const List<Color> primaryGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF0D0D1A),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFFFD700),
    Color(0xFFFFA000),
  ];

  static const List<Color> heroGradient = primaryGradient;
  static const List<Color> walletGradient = primaryGradient;
  static const List<Color> auroraGradient = primaryGradient;
  
  static const Color walletGradientStart = surface;
  static const Color walletGradientEnd = background;
  static const Color backgroundSoft = background;

  static Color get primary10 => accent.withOpacity(0.10);
  static Color get primary50 => accent.withOpacity(0.50);
}
