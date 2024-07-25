import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.primaryBlue,
    primaryColor: AppPalette.primaryBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      counterStyle: TextStyle(
        color: AppPalette.white, // Change this to your desired color
      ),
    ),
  );
}
