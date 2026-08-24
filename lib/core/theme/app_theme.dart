import 'package:flutter/material.dart';
import '../utils/colors.dart';


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.mainColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Cairo',
    textTheme: TextTheme(
      headlineLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: const TextStyle(fontSize: 16),
      bodyMedium: const TextStyle(fontSize: 14),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.mainColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mainColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}