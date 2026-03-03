import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anandham_user/app/theme/app_colors.dart';
import 'package:anandham_user/app/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final manjariFamily = GoogleFonts.manjari().fontFamily;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: const Color(0xFFEF476F),
      onSecondary: Colors.white,
      tertiary: const Color(0xFF06B6D4),
      onTertiary: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: manjariFamily,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF4F6FF),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimaryLight,
        surfaceTintColor: colorScheme.primary.withValues(alpha: 0.06),
      ),
      dividerColor: AppColors.borderLight,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.35)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      cardColor: Colors.white,
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: colorScheme.secondary.withValues(alpha: 0.05),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.14),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: AppColors.textSecondaryLight);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return const TextStyle(color: AppColors.textSecondaryLight);
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.secondary,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFF),
        labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
        hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.22)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.textPrimaryLight,
          fontFamily: manjariFamily,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textPrimaryLight,
          fontFamily: manjariFamily,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimaryLight,
          fontFamily: manjariFamily,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimaryLight,
          fontFamily: manjariFamily,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondaryLight,
          fontFamily: manjariFamily,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryLight,
          fontFamily: manjariFamily,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textPrimaryLight,
          fontFamily: manjariFamily,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textSecondaryLight,
          fontFamily: manjariFamily,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final manjariFamily = GoogleFonts.manjari().fontFamily;

    return ThemeData(
      useMaterial3: true,
      fontFamily: manjariFamily,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: Colors.white,
        secondary: AppColors.primaryDark,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
      ),
      dividerColor: AppColors.borderDark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: AppColors.textPrimaryDark,
          side: const BorderSide(color: AppColors.borderDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      cardColor: AppColors.surfaceDark,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryDark,
            width: 1.4,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.textPrimaryDark,
          fontFamily: manjariFamily,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textPrimaryDark,
          fontFamily: manjariFamily,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimaryDark,
          fontFamily: manjariFamily,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimaryDark,
          fontFamily: manjariFamily,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondaryDark,
          fontFamily: manjariFamily,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryDark,
          fontFamily: manjariFamily,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textPrimaryDark,
          fontFamily: manjariFamily,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textSecondaryDark,
          fontFamily: manjariFamily,
        ),
      ),
    );
  }
}
