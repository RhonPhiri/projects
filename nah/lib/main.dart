import 'package:flutter/material.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/hymnal_service.dart';
import 'package:nah/ui/core/theme/nah_theme.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymns/widgets/hymn_screen.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(MultiProvider(providers: [ChangeNotifierProvider(create:(context) => HymnalProvider(HymnalRepository(HymnalService())),)],child: const MyApp(),));

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
