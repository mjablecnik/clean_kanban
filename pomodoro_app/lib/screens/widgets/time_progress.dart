import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../timer_service.dart';

class TimeProgress extends StatelessWidget {
  const TimeProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerService>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                provider.currentDuration = 0;
                if (!provider.timerPlaying) provider.start();
                provider.notifyListeners();
              },
              child: Text(
                'SKIP',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.grey[200]),
              ),
            ),
            TextButton(
              onPressed: () {
                provider.currentDuration = provider.selectedTime;
                provider.notifyListeners();
              },
              child: Text(
                'RESET',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.grey[200]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${provider.rounds}/4",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            Text(
              "${provider.goal}/12",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'ROUND',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey[200]),
            ),
            Text(
              'GOAL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey[200]),
            )
          ],
        )
      ],
    );
  }
}
