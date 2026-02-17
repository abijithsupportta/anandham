import 'package:flutter/material.dart';

/// Shared brand colour palette for the Anandham platform.
class ColorConstants {
  ColorConstants._();

  // ── Primary ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42DB);

  // ── Secondary ──────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFFFF6584);
  static const Color secondaryLight = Color(0xFFFF8FA5);
  static const Color secondaryDark = Color(0xFFD44A66);

  // ── Accent ─────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF00BFA6);
  static const Color accentLight = Color(0xFF5DF2D6);
  static const Color accentDark = Color(0xFF008E76);

  // ── Neutral ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFFAFAFA);
  static const Color divider = Color(0xFFE0E0E0);

  // ── Text ───────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantics ──────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // ── Dark theme overrides ───────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
}
