import 'package:flutter/material.dart';
import 'package:pomodoro/screens/timer_service.dart';
import 'package:pomodoro/screens/widgets/time_progress.dart';
import 'package:pomodoro/screens/widgets/time_controller.dart';
import 'package:pomodoro/screens/widgets/timer_card.dart';
import 'package:pomodoro/screens/widgets/timer_options.dart';
import 'package:provider/provider.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerService>(context);
    return Scaffold(
      backgroundColor: provider.currentState == "FOCUS" ? Colors.redAccent : Colors.greenAccent,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: provider.currentState == "FOCUS" ? Colors.redAccent : Colors.greenAccent,
        title: const Text(
          'POMODORO',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 40,
            color: Colors.white,
            onPressed: () => Provider.of<TimerService>(context, listen: false).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const SizedBox(width: 600, child: FittedBox(fit: BoxFit.scaleDown, child: TimerCard())),
              const SizedBox(
                height: 50,
              ),
              TimerOptions(),
              const SizedBox(
                height: 100,
              ),
              const TimeController(),
              const SizedBox(
                height: 80,
              ),
              const TimeProgress()
            ],
          ),
        ),
      ),
    );
  }
}
