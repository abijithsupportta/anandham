import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Web-admin aligned accent colors
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryHover = Color(0xFF4338CA);
  static const Color primaryDark = Color(0xFF6366F1);
  static const Color primaryDarkHover = Color(0xFF818CF8);

  // Light mode colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderLightSubtle = Color(0xFFF3F4F6);
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color accentSubtleLight = Color(0xFFEEF2FF);

  // Dark mode colors
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color surfaceDark = Color(0xFF252526);
  static const Color borderDark = Color(0xFF3E3E3E);
  static const Color borderDarkSubtle = Color(0xFF333333);
  static const Color textPrimaryDark = Color(0xFFE4E4E7);
  static const Color textSecondaryDark = Color(0xFF888888);
  static const Color accentSubtleDark = Color(0xFF312E81);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color divider = borderLight;
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color shadow = Color(0x1A000000);
}
