import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  //Variable to hold the current themeMode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  //variable to hold the current themeColor
  ThemeColor _themeColor = ThemeColor.brown;
  ThemeColor get themeColor => _themeColor;

  //variable to hold the current font family
  FontFamily _fontFamily = FontFamily.lato;
  FontFamily get fontFamily => _fontFamily;

  //method to change the current theme variable based in the index of the clicked
  //coice chip in the modalBottomSheet and a string in reference to the variable being changed
  //utilizes switch statement to check the string variable provided and execute code only when the current variable
  //is different from the one being provided hence optimizing rebuilds
  //notifyListeners has been sepereted not called once at the end because each variable is independent of the other
  void changeVariable(int index, String variable) {
    switch (variable) {
      case 'themeMode':
        if (_themeMode != ThemeMode.values[index]) {
          _themeMode = ThemeMode.values[index];
          notifyListeners();
        }
        break;
      case 'themeColor':
        if (_themeColor != ThemeColor.values[index]) {
          _themeColor = ThemeColor.values[index];
          notifyListeners();
        }
        break;

      case 'fontFamily':
        if (_fontFamily != FontFamily.values[index]) {
          _fontFamily = FontFamily.values[index];
          notifyListeners();
        }
        break;
    }
  }

  //variable to hold the current font size
  int _fontSize = 16;
  int get fontSize => _fontSize;

  //method to whether increment/ decrement the fontSize depending on the button tapped
  void changeFontSize(int index) {
    if (index == 1 && _fontSize < 32) {
      _fontSize += 4;
      notifyListeners();
    } else if (index == 0 && _fontSize > 8) {
      _fontSize -= 4;
      notifyListeners();
    }
  }
}

//enum to hold the themeColors
enum ThemeColor {
  brown(Colors.brown),
  yellow(Colors.yellow),
  teal(Colors.tealAccent),
  blue(Colors.blue);

  final Color color;
  const ThemeColor(this.color);
}

//enum to hold the font families that have been downloaded by default and stored in the assets/fonts file
enum FontFamily { ledger, lato }
