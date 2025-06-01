import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/repositories/bookmark_repository.dart';
import 'package:nah/data/repositories/hymn_collection_repo.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/nah_services_export.dart';
import 'package:nah/ui/bookmarked_hymn/view_model/bookmarked_hymns_provider.dart';
import 'package:nah/ui/core/theme/nah_theme.dart';
import 'package:nah/ui/core/theme/theme_provider.dart';
import 'package:nah/ui/hymn_collection/view_model/hymn_collection_provider.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:nah/ui/hymn/widgets/hymn_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///variable to hold the DatabaseHelper instance
final dbHelper = DatabaseHelper();
Future<void> main() async {
  ///initialize
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeApp(dbHelper);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(prefs)),
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
        ChangeNotifierProvider(
          create:
              (context) => HymnCollectionProvider(HymnCollectionRepo(dbHelper)),
        ),
        ChangeNotifierProvider(
          create:
              (context) => BookmarkedHymnsProvider(
                HymnRepository(HymnService(), dbHelper),
                BookmarkRepository(dbHelper),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );

  ///close database and release resources
  // await closeDatabaseOnAppExit(dbHelper);
}

///method to initalize the app & database
Future<void> initializeApp(DatabaseHelper dbHelper) async {
  try {
    await dbHelper.database;
  } catch (e) {
    debugPrint('Error initializing the database: $e');
  }
}

// ///method to release database resources upon closing the app
// Future<void> closeDatabaseOnAppExit(DatabaseHelper dbHelper) async {
//   await dbHelper.close();
//   debugPrint('database closed successfully!!!');
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final thememode = context.watch<ThemeProvider>().themeMode;
    return MaterialApp(
      theme: NahTheme.light(),
      darkTheme: NahTheme.dark(),
      themeMode: thememode,
      home: HymnScreen(),
    );
  }
}
