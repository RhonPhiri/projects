import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  //will use Dependency Injection to initialize the sharedPrefs
  final SharedPreferences _prefs;
  ThemeProvider(this._prefs) {
    loadAppTheme();
  }
  //variable holding the font size
  static const double defaultFontSize = 16.0;
  double _fontsize = defaultFontSize;
  double get fontSize => _fontsize;

  //method to change and save the font size
  Future<void> changeFontSize(double newFontsize) async {
    //load shared preferences
    try {
      _fontsize = newFontsize;
      //store the current font
      await _prefs.setDouble('hymn_fontsize', newFontsize);
    } catch (e) {
      debugPrint('Error saving fontSize: $e');
    }
  }

  //variable holding the app thememode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  //method to change the app theme
  Future<void> changeAppTheme(int index) async {
    //check if index is in valid range
    if (index < 0 || index > ThemeMode.values.length) {
      debugPrint('Invalid theme index: $index');
      return;
    }
    //load the shared preferences
    try {
      //asign the thememode based on the tapped index
      _themeMode = ThemeMode.values[index];
      //store the current thememode after changing
      await _prefs.setInt('hymn_themeMode', index);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving the thememode: $e');
    }
  }

  //method to load the saved theme
  Future<void> loadAppTheme() async {
    //get the stored fontSize
    try {
      _fontsize = _prefs.getDouble('hymn_fontsize') ?? defaultFontSize;
      // get the stored index for the themeMode
      final themeModeIndex = _prefs.getInt('hymn_themeMode') ?? 2;
      _themeMode = ThemeMode.values[themeModeIndex];
    } catch (e) {
      debugPrint('Error loading appTheme: $e');
    } finally {
      notifyListeners();
    }
  }
}

class AppTheme {
  static final lightDrawerGradient = [
    Colors.grey.shade100,
    Colors.grey.shade200,
    Colors.grey.shade400,
  ];
  static final darkDrawerGradient = [
    Colors.black87,
    Colors.grey.shade800,
    Colors.grey.shade700,
  ];

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        primary: Color(0xFF0168B5),
        onPrimary: Color(0xFF000000),
        secondary: Color(0xFF007BD8),
        onSecondary: Color(0xFF000000),
        tertiary: Color(0xFF0089F1),
        onTertiary: Color(0xFF000000),
        error: Color(0xFFF44336),
        onError: Color(0xFFFFFFFF),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF000000),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF000000),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: Color(0xFFE3F2FD),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: Colors.grey.shade200,
      ),
      sliderTheme: const SliderThemeData(
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        primary: Color(0xFF0168B5),
        onPrimary: Colors.white,
        secondary: Color(0xFF007BD8),
        onSecondary: Colors.white,
        tertiary: Color(0xFF0089F1),
        onTertiary: Colors.black,
        error: Color(0xFFF44336),
        onError: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF000000),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFFFFFFFF),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: Color(0xFF212121),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: Colors.grey.shade900,
      ),
      sliderTheme: const SliderThemeData(
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
