import 'package:flutter/material.dart';

class NahTheme {
  //Gradient colors for the drawer
  static final lightDrawerGradientColors = [
    Colors.grey.shade100,
    Colors.grey.shade200,
    Colors.grey.shade400,
  ];
  static final darkDrawerGradientColors = [
    Colors.black87,
    Colors.grey.shade800,
    Colors.grey.shade700,
  ];

  static ThemeData light() {
    return ThemeData(
      // Material 3 is enabled project-wide for consistent theming.
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF0168B5),
        onPrimary: const Color(0xFF000000),
        secondary: const Color(0xFF007BD8),
        onSecondary: const Color(0xFF000000),
        tertiary: const Color(0xFF0089F1),
        onTertiary: const Color(0xFF000000),
        error: const Color(0xFFF44336),
        onError: const Color(0xFFFFFFFF),
      ),
      appBarTheme: _sharedAppBarTheme(true),
      dividerTheme: _sharedDividerThemeData(true),

      // The light theme uses Colors.grey.shade200 for the bottom sheet background
      // to provide a subtle contrast with the light theme's primary colors.
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: Colors.grey.shade200,
      ),
      sliderTheme: _sharedSliderTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF0168B5),
        onPrimary: Colors.white,
        secondary: const Color(0xFF007BD8),
        onSecondary: Colors.white,
        tertiary: const Color(0xFF0089F1),
        onTertiary: Colors.white,
      ),
      appBarTheme: _sharedAppBarTheme(false),
      dividerTheme: _sharedDividerThemeData(false),
      sliderTheme: _sharedSliderTheme,
    );
  }

  /// Returns a shared AppBarTheme based on the given brightness.
  /// This method ensures consistent styling for app bars in both light and dark themes.
  static AppBarTheme _sharedAppBarTheme(bool isLightTheme) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: isLightTheme ? Colors.white : Colors.black,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: isLightTheme ? Colors.black : Colors.white,
      ),
    );
  }

  /// Returns a shared SliderThemeData so that the text color is maintained in both light & dark modes
  static const SliderThemeData _sharedSliderTheme = SliderThemeData(
    valueIndicatorTextStyle: TextStyle(color: Colors.white),
  );

  /// returns a shared DivderThemeData depending on the brightness
  static DividerThemeData _sharedDividerThemeData(bool isLightTheme) =>
      DividerThemeData(
        thickness: 1,
        color: isLightTheme ? Color(0xFFE3F2FD) : Color(0xFF212121),
      );
}
