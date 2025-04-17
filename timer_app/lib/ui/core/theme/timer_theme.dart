import 'package:flutter/material.dart';

class TimerTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.blue.shade50,
        onPrimary: Colors.black,
        secondary: Colors.blue.shade100,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        surface: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFF000000),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.blue.shade300,
        onPrimary: Colors.white,
        secondary: Colors.blue.shade200,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: const Color(0xFF000000),
        onSurface: const Color(0xFFFFFFFF),
      ),
    );
  }
}
