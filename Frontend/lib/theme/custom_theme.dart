import 'package:flutter/material.dart';
import 'color_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get customTheme {
    return _customTheme;
  }

  static final ThemeData _customTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkblue, brightness: Brightness.light),
    useMaterial3: true,
    fontFamily: GoogleFonts.itim().fontFamily,

    // fontFamily: "Itim",
    scaffoldBackgroundColor: AppColors.blue,
    primaryColor: AppColors.darkblue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          AppColors.darkblue,
        ),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
        foregroundColor: const WidgetStatePropertyAll<Color>(
          AppColors.cream,
        ),
        textStyle: const WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            color: AppColors.cream,
          ),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        AppColors.white,
      ),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(color: AppColors.darkblue, width: 2),
      ),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      )),
    )),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.yellow,
        iconSize: 50,
        foregroundColor: AppColors.cream),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      backgroundColor: AppColors.white,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 32,
        color: AppColors.darkblue,
        fontFamily: 'Itim',
      ),
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all<Color>(AppColors.blue),
        checkColor: WidgetStateProperty.all<Color>(AppColors.white),
        side: const BorderSide(color: Colors.transparent)),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 50, color: AppColors.black),
      headlineMedium: TextStyle(fontSize: 32, color: AppColors.black),
      headlineSmall: TextStyle(fontSize: 24, color: AppColors.black),
      bodyLarge: TextStyle(fontSize: 20, color: AppColors.black),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.black),
      bodySmall: TextStyle(fontSize: 14, color: AppColors.black),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppColors.darkblue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(
        color: AppColors.darkblue,
      ),
      hintStyle: TextStyle(
        color: AppColors.darkblue,
      ),
      fillColor: AppColors.grey,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    ),
  );
}
