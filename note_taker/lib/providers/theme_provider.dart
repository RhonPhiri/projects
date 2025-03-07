import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() {
    loadAppTheme();
  }
  //Variable to hold the current themeMode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  //variable to hold the current themeColor
  ThemeColor _themeColor = ThemeColor.brown;
  ThemeColor get themeColor => _themeColor;
  //variable to hold the current textTheme
  NoteTextTheme _noteTextTheme = NoteTextTheme.ledger;
  NoteTextTheme get noteTextTheme => _noteTextTheme;
  //method to load variables of the current theme setiings
  Future<void> loadAppTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeModeIndex') ?? 2];
    _themeColor = ThemeColor.values[prefs.getInt('themeColorIndex') ?? 0];
    _noteTextTheme =
        NoteTextTheme.values[prefs.getInt('noteTextThemeIndex') ?? 0];
    _fontSize = prefs.getInt('fontSize') ?? 16;
    notifyListeners();
  }

  //method to change the current theme variable based in the index of the clicked
  //choice chip in the modalBottomSheet and a string in reference to the variable being changed
  //utilizes switch statement to check the string variable provided and execute code only when the current variable
  //is different from the one being provided hence optimizing rebuilds
  //notifyListeners has been sepereted not called once at the end because each variable is independent of the other
  Future<void> changeVariable(int index, String variable) async {
    final prefs = await SharedPreferences.getInstance();
    switch (variable) {
      case 'themeMode':
        if (_themeMode != ThemeMode.values[index]) {
          _themeMode = ThemeMode.values[index];
          prefs.setInt('themeModeIndex', index);
          notifyListeners();
        }
        break;
      case 'themeColor':
        if (_themeColor != ThemeColor.values[index]) {
          _themeColor = ThemeColor.values[index];
          prefs.setInt('themeColorIndex', index);
          notifyListeners();
        }
        break;
      case 'textTheme':
        if (_noteTextTheme != NoteTextTheme.values[index]) {
          _noteTextTheme = NoteTextTheme.values[index];
          prefs.setInt('noteTextThemeIndex', index);
          notifyListeners();
        }
    }
  }

  //variable to hold the current font size
  late int _fontSize = 16;
  int get fontSize => _fontSize;

  //method to whether increment/ decrement the fontSize depending on the button tapped
  Future<void> changeFontSize(int index) async {
    final prefs = await SharedPreferences.getInstance();
    if (index == 1 && _fontSize < 32) {
      _fontSize += 4;

      notifyListeners();
    } else if (index == 0 && _fontSize > 8) {
      _fontSize -= 4;
      notifyListeners();
    }
    prefs.setInt('fontSize', _fontSize);
  }
}

//enum to hold the themeColors
enum ThemeColor {
  brown(Colors.brown),
  purple(Colors.deepPurpleAccent),
  green(Colors.greenAccent),
  blue(Colors.blue);

  final Color color;
  const ThemeColor(this.color);
}

//enum to hold the font families that have been downloaded by default and stored in the assets/fonts file
enum NoteTextTheme { ledger, workSans, josefinSans }
