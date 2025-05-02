import 'package:flutter/material.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/hymnal_service.dart';
import 'package:nah/ui/core/theme/nah_theme.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymns/widgets/hymn_screen.dart';
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
              (context) =>
                  HymnalProvider(HymnalRepository(HymnalService(), dbHelper)),
        ),
      ],
      child: const MyApp(),
    ),
  );

  //close database resources
  await closeDatabaseOnAppExit(dbHelper);
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
      themeMode: ThemeMode.dark,
      home: HymnScreen(),
    );
  }
}
