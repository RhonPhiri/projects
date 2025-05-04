import 'package:flutter/material.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/nah_services_export.dart';
import 'package:nah/ui/core/theme/nah_theme.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:nah/ui/hymn/widgets/hymn_screen.dart';
import 'package:provider/provider.dart';

//variable to hold the DatabaseHelper instance
final dbHelper = DatabaseHelper();
Future<void> main() async {
  //initialize
  await initializeApp(dbHelper);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) => HymnalProvider(
                HymnRepository(HymnService(), dbHelper),
                HymnalRepository(HymnalService(), dbHelper),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  HymnProvider(HymnRepository(HymnService(), dbHelper)),
        ),
      ],
      child: const MyApp(),
    ),
  );

  //close database and release resources
  // await closeDatabaseOnAppExit(dbHelper);
}

//method to initalize the app & database
Future<void> initializeApp(DatabaseHelper dbHelper) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dbHelper.database;
  } catch (e) {
    debugPrint('Error initializing the database: $e');
  }
}

//method to release database resources upon closing the app
Future<void> closeDatabaseOnAppExit(DatabaseHelper dbHelper) async {
  await dbHelper.close();
  debugPrint('database closed successfully!!!');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: NahTheme.light(),
      darkTheme: NahTheme.dark(),
      themeMode: ThemeMode.light,
      home: HymnScreen(),
    );
  }
}
