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
