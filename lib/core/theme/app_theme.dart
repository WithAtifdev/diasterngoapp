import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {

  // ================= CUSTOM COLORS =================

  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color surfaceColor = AppColors.card;
  static const Color borderColor = Colors.white10;
  static const Color accentBlue = AppColors.primaryBlue;
  static const Color textSecondary = Colors.white70;

  // ================= DARK THEME =================

  static ThemeData darkTheme = ThemeData(

    useMaterial3: true,
    brightness: Brightness.dark,

    fontFamily: 'Poppins',

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryBlue,
      surface: AppColors.card,
    ),

    // ================= APPBAR =================

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ================= CARD =================

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ================= NAVIGATION =================

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.grey.shade900,
      indicatorColor: Colors.white.withValues(alpha: 0.15),

      labelTextStyle: WidgetStateProperty.resolveWith((states) {

        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          );
        }

        return TextStyle(
          color: Colors.grey.shade400,
        );
      }),
    ),

    // ================= INPUT =================

    inputDecorationTheme: InputDecorationTheme(

      filled: true,
      fillColor: AppColors.card,

      hintStyle: const TextStyle(
        color: Colors.white38,
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primaryBlue,
          width: 1.2,
        ),
      ),
    ),

    // ================= BUTTON =================

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(

        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,

        elevation: 0,

        minimumSize: const Size(
          double.infinity,
          55,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ================= SNACKBAR =================

    snackBarTheme: SnackBarThemeData(

      backgroundColor: AppColors.card,

      behavior: SnackBarBehavior.floating,

      contentTextStyle: const TextStyle(
        color: Colors.white,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // ================= DIVIDER =================

    dividerTheme: const DividerThemeData(
      color: Colors.white10,
      thickness: 1,
    ),

    // ================= TEXT =================

    textTheme: const TextTheme(

      headlineLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      bodyLarge: TextStyle(
        color: Colors.white,
      ),

      bodyMedium: TextStyle(
        color: Colors.white70,
      ),
    ),
  );
}