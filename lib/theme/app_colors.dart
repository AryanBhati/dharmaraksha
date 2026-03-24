import 'package:flutter/material.dart';

/// Trust Blue + Saffron Palette for DharamRaksha
///
/// Designed to convey trust, clarity, and authority in the LegalTech space.
class AppColors {
  AppColors._();

  // ─── Primary Brand Colors ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF0B3C5D);         // Deep Blue (Trust/Authority)
  static const Color accent = Color(0xFFF4A261);          // Saffron Accent
  static const Color secondary = accent;

  // ─── Light Theme Colors ────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F7FA); // Light Grey
  static const Color surfaceLight = Colors.white;         // White
  
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color iconLight = Color(0xFF475569);

  // ─── Dark Theme Colors ─────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);

  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  static const Color borderDark = Color(0xFF30363D);
  static const Color iconDark = Color(0xFF94A3B8);

  // ─── Semantic Colors ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF2A9D8F); // Green
  static const Color error = Color(0xFFD62828);   // Red
  static const Color warning = Color(0xFFE9C46A); // Orange/Warning

  // ─── Aliased Variables (For Contextual Usage) ──────────────────────────────
  static const Color background = backgroundLight;
  static const Color surface = surfaceLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color border = borderLight;

  static Color get glassColor => Colors.white.withOpacity(0.05);
  static Color get glassBorder => Colors.white.withOpacity(0.1);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF0B3C5D),
    Color(0xFF082D45),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFF4A261),
    Color(0xFFE76F51),
  ];

  static Color get primary10 => primary.withOpacity(0.10);
  static Color get primary50 => primary.withOpacity(0.50);
  
  static Color get accent10 => accent.withOpacity(0.10);
}
