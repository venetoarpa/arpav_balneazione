import 'package:flutter/material.dart';

final ThemeData CompanyThemeData = new ThemeData(
    brightness: Brightness.light,

    primaryColor: CompanyColors.green[50],
    primaryColorBrightness: Brightness.light,
    accentColor: CompanyColors.green[100],
    accentColorBrightness: Brightness.light
);

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class
  static const MaterialColor green = const MaterialColor(
      0xFF2d7167,
      const <int, Color> {
        50: const Color(0xFF2d7167),
        100: const Color(0xFF2d7167),
        200: const Color(0xFF2d7167),
        300: const Color(0xFF2d7167),
        400: const Color(0xFF2d7167),
        500: const Color(0xFF2d7167),
        600: const Color(0xFF2d7167),
        700: const Color(0xFF2d7167),
        800: const Color(0xFF2d7167),
        900: const Color(0xFF2d7167),
  });
  

}