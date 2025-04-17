import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer_app/home_screen.dart';
import 'package:timer_app/ui/core/theme/timer_theme.dart';

void main() async {
  //ensure flutter is fully initialized before calling an asynchronous code
  WidgetsFlutterBinding.ensureInitialized();
  //force the phone orientation to be in a landscape mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  //allow full screen display scroll down to show system overays
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: TimerTheme.light(),
      darkTheme: TimerTheme.dark(),
      home: HomeScreen(),
    );
  }
}
