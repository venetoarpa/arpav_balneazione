import 'package:flutter/material.dart';

final ThemeData CompanyThemeData = new ThemeData(
    brightness: Brightness.light,

    primaryColor: CompanyColors.green[50],
    primaryColorBrightness: Brightness.light,
    accentColor: CompanyColors.green[100],
    accentColorBrightness: Brightness.light
);

class CompanyColors {
  CompanyColors._();
  // this basically makes it so you can instantiate this class
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

  static const MaterialColor grey = const MaterialColor(
      0xFFd7d7d7,
      const <int, Color> {
        50: const Color(0xFFd7d7d7),
        100: const Color(0xFFd7d7d7),
        200: const Color(0xFFd7d7d7),
        300: const Color(0xFFd7d7d7),
        400: const Color(0xFFd7d7d7),
        500: const Color(0xFFd7d7d7),
        600: const Color(0xFFd7d7d7),
        700: const Color(0xFFd7d7d7),
        800: const Color(0xFFd7d7d7),
        900: const Color(0xFFd7d7d7),
      });

  static const MaterialColor bluette = const MaterialColor(
      0xFFe2e6f1,
      const <int, Color> {
        50: const Color(0xFFe2e6f1),
        100: const Color(0xFFe2e6f1),
        200: const Color(0xFFe2e6f1),
        300: const Color(0xFFe2e6f1),
        400: const Color(0xFFe2e6f1),
        500: const Color(0xFFe2e6f1),
        600: const Color(0xFFe2e6f1),
        700: const Color(0xFFe2e6f1),
        800: const Color(0xFFe2e6f1),
        900: const Color(0xFFe2e6f1),
      });
//e2e6f1
}