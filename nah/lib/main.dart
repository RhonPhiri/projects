import 'package:flutter/material.dart';
import 'package:nah/ui/core/theme/nah_theme.dart';
import 'package:nah/ui/hymns/widgets/hymn_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: NahTheme.light(),
      darkTheme: NahTheme.dark(),
      themeMode: ThemeMode.dark,
      home: HymnScreen(),
    );
  }
}
