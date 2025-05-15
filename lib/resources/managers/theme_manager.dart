import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class ThemeManager {
  ThemeManager._();

  static ThemeData getTheme(BuildContext context) => ThemeData(
      useMaterial3: true,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.appbarBackground,
          extendedPadding: EdgeInsets.all(16),
          hoverColor: AppColors.blue,
          foregroundColor: Colors.white),
      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: const Color.fromRGBO(42, 176, 94, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.appbarBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color.fromRGBO(228, 241, 233, 1),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: const WidgetStatePropertyAll<Color?>(Colors.white),
        checkColor: WidgetStatePropertyAll<Color?>(
          Colors.red[300],
        ),
      ),
      textTheme: TextTheme(
          headlineMedium: GoogleFonts.poppins(),
          labelLarge: GoogleFonts.poppins(
            color: const Color.fromRGBO(42, 176, 94, 1),
            fontWeight: FontWeight.w600,
          )));

  static ThemeData getDarkTheme() => ThemeData.dark();
}
