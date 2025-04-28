import 'dart:async';

import 'package:flutter/material.dart';

class TimerViewModel with ChangeNotifier {
  //variable to hold the set time in minutes
  int setTime = 2 * 60;
  //variable to hold the timeleft in secondes
  int timeLeft = 2 * 60;

  //variable to change the pause/ start button
  bool isCountingDown = false;

  //method to start the counter
  void startCounter() {
    isCountingDown = true;
    notifyListeners();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0 && isCountingDown) {
        timeLeft--;
      } else {
        isCountingDown = false;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  //method to stop the counter
  void stopCounter() {
    isCountingDown = false;
    notifyListeners();
  }
}
