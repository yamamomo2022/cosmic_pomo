import 'package:flutter/material.dart';

import 'screens/pomodoro_screen.dart';

void main() async {
  // Flutter binding の初期化を確実に行う
  WidgetsFlutterBinding.ensureInitialized();

  // アプリ起動時はウェイクロックを有効にせず、PomodoroScreen で管理する
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cosmic Pomo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PomodoroScreen(),
    );
  }
}
