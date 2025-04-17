import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/hymnal/widgets/hymnal_screen.dart';

class HymnScreen extends StatelessWidget {
  HymnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(
            title: 'H O M E  P A G E',
            leading: AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: Icon(Icons.menu),
            ),
            actions: List.generate(2, (int index) {
              final searchIconPressed = index == 0;
              return IconButton(
                onPressed: () async {
                  searchIconPressed
                      ? null
                      : Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HymnalScreen()),
                      );
                },
                icon: Icon(searchIconPressed ? Icons.search : Icons.book),
              );
            }),
          ),
        ],
      ),
    );
  }
}
