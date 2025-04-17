import 'package:flutter/material.dart';
import 'package:nac_hymnal/pages/pages.dart';
import 'package:nac_hymnal/providers/audio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/providers.dart';
import 'package:provider/provider.dart';

void main() async {
  //This will ensure flutter is well & fully initialized before calling an
  //asynchronous code
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HymnProvider()),
        //inject the sharedPrefs an a dependency into themeProvider
        ChangeNotifierProvider(create: (context) => ThemeProvider(sharedPrefs)),
        ChangeNotifierProvider(create: (context) => HymnalProvider()),
        ChangeNotifierProvider(create: (context) => HymnCollectionProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkedHymnsProvider()),
        ChangeNotifierProvider(create: (context) => AudioProvider()),
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
    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const HomePage(),
    );
  }
}
