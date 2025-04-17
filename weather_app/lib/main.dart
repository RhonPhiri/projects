import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color colorSelected = ColorSelection.blue.color;

  void changeColor(int index) {
    setState(() {
      colorSelected = ColorSelection.values[index].color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(colorSelected),
      home: WeatherPage(
        colorSelected: colorSelected,
        changeColor: (p0) => changeColor(p0),
      ),
    );
  }
}
