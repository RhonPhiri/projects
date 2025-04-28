import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/timer/timer_view_model.dart';

class TimerView extends StatelessWidget {
  TimerView({super.key});

  //A list of buttons displayed on the homescreen
  final iconButtonList = <String>['skip', 'pause', 'restart'];

  @override
  Widget build(BuildContext context) {
    //variable storing the size of the iconButtons
    final iconSize = 48.0;
    //access the timer provider
    final timerViewModel = context.watch<TimerViewModel>();
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Theme.of(context).colorScheme.primary.withAlpha(64),
            //       ),
            //       borderRadius: BorderRadius.circular(24),
            //     ),
            //     margin: const EdgeInsets.only(top: 64.0, right: 24),
            //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            //     child: Text('Next session: 5 min break'),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: CircularProgressIndicator(
                          value:
                              (timerViewModel.timeLeft /
                                  timerViewModel.setTime),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.2),
                        ),
                      ),
                      Text(
                        timerViewModel.timeLeft >= 60
                            ? "${(timerViewModel.timeLeft / 60).toInt()} min"
                            : "${timerViewModel.timeLeft} sec",
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                ),

                ...List.generate(iconButtonList.length, (int index) {
                  return IconButton(
                    onPressed: () {
                      if (iconButtonList[index] == 'pause') {
                        if (timerViewModel.isCountingDown) {
                          timerViewModel.stopCounter();
                        } else {
                          timerViewModel.startCounter();
                        }
                      }
                    },
                    icon: Icon(
                      //a button to allow the user to skip to the break/ next session
                      iconButtonList[index] == 'skip'
                          ? Icons.arrow_forward_ios_rounded
                          //icon to allow the user reset the session
                          : iconButtonList[index] == 'restart'
                          ? Icons.rotate_left_rounded
                          : timerViewModel.isCountingDown
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: iconSize,
                    ),
                  );
                }),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
