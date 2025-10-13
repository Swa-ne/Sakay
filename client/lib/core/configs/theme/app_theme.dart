import 'package:flutter/material.dart';
import 'package:sakay_app/core/configs/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        surfaceTintColor: AppColors.lightBackground),
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF00A2FF),
      selectionColor: Color(0xFF00A2FF),
      selectionHandleColor: Color(0xFF00A2FF),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: Color(0xFF00A2FF)),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF00A2FF),
      selectionColor: Color(0xFF00A2FF),
      selectionHandleColor: Color(0xFF00A2FF),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: Color(0xFF00A2FF)),
    ),
  );
}
