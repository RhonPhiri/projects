import 'package:file_downloader/pages/downloads_page.dart';
import 'package:file_downloader/pages/home_page.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  //index for the Navigationbar
  int _selectedIndex = 0;
  //list of pages
  final pages = <Widget>[HomePage(), DownloadsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.link), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.download), label: 'Downloads'),
        ],
      ),
    );
  }
}
