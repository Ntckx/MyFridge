import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'color_theme.dart';

class CustomTheme {
  static ThemeData get customTheme {
    return _customTheme;
  }

  static final ThemeData _customTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkblue, brightness: Brightness.light),
    useMaterial3: true,
    fontFamily: "Itim",
    scaffoldBackgroundColor: AppColors.blue,
    primaryColor: AppColors.darkblue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppColors.darkblue,
        ),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
        foregroundColor: MaterialStatePropertyAll<Color>(
          AppColors.cream,
        ),
        textStyle: MaterialStatePropertyAll<TextStyle>(
          TextStyle(
            color: AppColors.cream,
          ),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        AppColors.cream,
      ),
      side: MaterialStateProperty.all<BorderSide>(
        BorderSide(color: AppColors.darkblue, width: 1),
      ),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
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
      backgroundColor: AppColors.cream,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 32,
        color: AppColors.black,
        fontFamily: 'Itim',
      ),
    ),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(AppColors.cream),
        checkColor: MaterialStateProperty.all<Color>(AppColors.black),
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
      labelStyle: TextStyle(
        color: AppColors.darkblue,
      ),
      hintStyle: TextStyle(
        color: AppColors.darkblue,
      ),
      fillColor: AppColors.cream,
      filled: true,
    ),

    // expansionTileTheme: const ExpansionTileThemeData(
    //     shape: Border(), backgroundColor: Colors.white),

    //     elevatedButtonTheme: ElevatedButtonThemeData(
    //     style: ButtonStyle(
    //   backgroundColor: WidgetStateProperty.all<Color>(
    //     AppColors.yellow,
    //   ),
    //   foregroundColor: WidgetStateProperty.all<Color>(
    //     AppColors.white,
    //   ),
    //   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    //     RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    //   textStyle: WidgetStateProperty.all<TextStyle>(
    //     const TextStyle(
    //       fontWeight: FontWeight.w800,
    //       fontSize: 18,
    //       color: AppColors.white,
    //     ),
    //   ),
    //   fixedSize: WidgetStateProperty.all<Size>(
    //     const Size.fromHeight(50),
    //   ),
    //   elevation:
    //       WidgetStateProperty.all<double>(0),
    // )),
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //   style: ButtonStyle(
    //     backgroundColor: WidgetStateProperty.all<Color>(AppColors.white),
    //     foregroundColor: WidgetStateProperty.all<Color>(
    //       AppColors.darkGrey,
    //     ),
    //     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //         side: const BorderSide(
    //           color: AppColors.lightGrey, // Set the color of the border
    //           width: 1, // Set the width of the border
    //         ),
    //       ),
    //     ),
    //     textStyle: WidgetStateProperty.all<TextStyle>(
    //       const TextStyle(
    //         fontWeight: FontWeight.w500,
    //         fontSize: 18,
    //         color: AppColors.darkGrey,
    //       ),
    //     ),
    //     fixedSize: WidgetStateProperty.all<Size>(const Size.fromHeight(50)),
    //     elevation:
    //         WidgetStateProperty.all<double>(0), // Remove the elevation here
    //   ),
    // ),
    // textTheme: const TextTheme(
    //   headlineLarge: TextStyle(
    //       fontWeight: FontWeight.w600, fontSize: 40, color: AppColors.darkGrey),
    //   headlineMedium: TextStyle(
    //       fontWeight: FontWeight.w600, fontSize: 20, color: AppColors.darkGrey),
    //   headlineSmall: TextStyle(
    //       fontWeight: FontWeight.w600, fontSize: 20, color: AppColors.darkGrey),
    //   bodyLarge: TextStyle(
    //       fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.darkGrey),
    //   bodyMedium: TextStyle(
    //       fontWeight: FontWeight.w500, fontSize: 18, color: AppColors.darkGrey),
    //   bodySmall: TextStyle(
    //       fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.darkGrey),
    // ),
  );
}