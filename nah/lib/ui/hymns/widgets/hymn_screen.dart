import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymnal/widgets/hymnal_screen.dart';
import 'package:provider/provider.dart';

class HymnScreen extends StatefulWidget {
  const HymnScreen({super.key});

  @override
  State<HymnScreen> createState() => _HymnScreenState();
}

class _HymnScreenState extends State<HymnScreen> {
  @override
  void initState() {
    super.initState();
    //defer the call to loadHymnals() until after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HymnalProvider>().loadHymnals();
    });
  }

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
