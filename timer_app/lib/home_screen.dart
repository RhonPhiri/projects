import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  //A list of buttons displayed on the homescreen
  final iconButtonList = <String>['skip', 'pause', 'restart'];

  @override
  Widget build(BuildContext context) {
    //variable storing the size of the iconButtons
    final iconSize = 48.0;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withAlpha(64),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                margin: const EdgeInsets.only(top: 64.0, right: 24),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Text('Next session: 5 min break'),
              ),
            ),
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
                          value: 0.5,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.2),
                        ),
                      ),
                      Text('12 min', style: TextStyle(fontSize: 32)),
                    ],
                  ),
                ),

                ...List.generate(iconButtonList.length, (int index) {
                  return IconButton(
                    onPressed: () {},
                    icon: Icon(
                      //a button to allow the user to skip to the break/ next session
                      iconButtonList[index] == 'skip'
                          ? Icons.arrow_forward_ios_rounded
                          //icon to allow the user to pause/ continue a session
                          : iconButtonList[index] == 'pause'
                          ? Icons.pause_rounded
                          //icon to allow the user reset the session
                          : Icons.rotate_left_rounded,
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
