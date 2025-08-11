import 'package:flutter/material.dart';
import 'package:pomodoro/screens/timer_service.dart';
import 'package:provider/provider.dart';

import 'screens/pomodoro_screen.dart';

void main() => runApp(ChangeNotifierProvider<TimerService>(
      create: (_) => TimerService(),
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PomodoroScreen(),
    );
  }
}


class PomodoroView extends StatelessWidget {
  const PomodoroView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerService>(
      create: (_) => TimerService(),
      child: const PomodoroScreen(),
    );
  }
}

