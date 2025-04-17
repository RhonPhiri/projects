import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_taker/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page/home_page.dart';
import 'models/models.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColor = themeProvider.themeColor.color;
    final noteTextTheme = switch (themeProvider.noteTextTheme.name) {
      'ledger' => GoogleFonts.ledgerTextTheme(),
      'workSans' => GoogleFonts.workSansTextTheme(),
      _ => GoogleFonts.josefinSansTextTheme(),
    };
    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor,
          brightness: Brightness.light,
        ),
        textTheme: noteTextTheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor,
          brightness: Brightness.dark,
        ),
        textTheme: noteTextTheme,
      ),
      home: const HomePage(),
    );
  }
}
