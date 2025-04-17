import 'package:flutter/material.dart';

enum ColorSelection {
  yellow('Yellow', Color(0xFFFFE142)),
  blue('Blue', Color(0xFF87CEFA)),
  pink('Pink', Color(0xFFFF64D4)),
  white('White', Color(0xFFFFFFFF)),
  black('Grey', Color(0XFF696969));

  const ColorSelection(this.label, this.color);

  final String label;
  final Color color;
}

ThemeData themeData(Color colorSelected) {
  if (colorSelected == ColorSelection.black.color) {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.grey.shade800,
            onPrimary: Colors.white,
            secondary: Colors.grey.shade700,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.grey.shade900,
            onSurface: Colors.white));
  }
  return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: colorSelected,
          secondary: Colors.grey.shade900,
          onSecondary: colorSelected,
          error: Colors.red,
          onError: Colors.white,
          surface: colorSelected,
          onSurface: Colors.black));
}
