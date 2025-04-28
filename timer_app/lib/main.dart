import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/timer/timer_view.dart';
import 'package:timer_app/timer/timer_view_model.dart';
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
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: TimerTheme.light(),
      darkTheme: TimerTheme.dark(),
      home: TimerView(),
    );
  }
}
