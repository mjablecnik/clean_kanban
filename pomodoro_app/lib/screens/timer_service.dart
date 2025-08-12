import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerService extends ChangeNotifier {
  late Timer timer;
  double currentDuration = 1500;
  double selectedTime = 1500;
  bool timerPlaying = false;
  int rounds = 0;
  int goal = 0;
  String currentState = "FOCUS";
  String? soundPath;
  Function? callback;

  TimerService({this.soundPath, this.callback});

  playAlarm() async {
    if (soundPath != null) {
      final player = AudioPlayer();
      player.setVolume(1);
      await player.play(AssetSource(soundPath!));
      Future.delayed(const Duration(seconds: 2), () => player.stop());
    }
  }

  setCallback(Function callback) {
    this.callback = callback;
  }

  void start() {
    timerPlaying = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (currentDuration == 0) {
        handleNextRound();
        pause();
        playAlarm();
        await callback?.call();
      } else {
        currentDuration--;
        notifyListeners();
      }
    });
  }

  void pause() {
    timer.cancel();
    timerPlaying = false;
    notifyListeners();
  }

  void reset() {
    timer.cancel();
    currentState = "FOCUS";
    currentDuration = selectedTime = 1500;
    //rounds = goal = 0;
    timerPlaying = false;
    notifyListeners();
  }

  void selectTime(double seconds) {
    selectedTime = seconds;
    currentDuration = seconds;
    notifyListeners();
  }

  void handleNextRound() {
    if (currentState == "FOCUS" && rounds != 3) {
      currentState = "BREAK";
      currentDuration = selectedTime;
      //selectedTime = 300;
      rounds++;
      goal++;
    } else if (currentState == "BREAK") {
      currentState = "FOCUS";
      currentDuration = selectedTime;
      //selectedTime = 1500;
    } else if (currentState == "FOCUS" && rounds == 3) {
      currentState = "LONG BREAK";
      currentDuration = selectedTime;
      //selectedTime = 1500;
      rounds++;
      goal++;
    } else if (currentState == "LONG BREAK") {
      currentState = "FOCUS";
      currentDuration = selectedTime;
      //selectedTime = 1500;
      rounds = 0;
    }
    notifyListeners();
  }
}
