import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/erro_message_with_retry.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/core/ui/sliver_hymn_list.dart';
import 'package:nah/ui/hymn/widgets/drawer/nah_drawer.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymnal/widgets/hymnal_screen.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<HymnalProvider>().loadHymnals();

      //If the widget is mounted in the widget tree, run the following callbacks
      if (!mounted) return;
      // After hymnals are loaded, load hymns for the selected hymnal
      final hymnalProvider = context.read<HymnalProvider>();
      if (hymnalProvider.hymnals.isNotEmpty) {
        final selectedHymnal =
            hymnalProvider.hymnals[hymnalProvider.selectedHymnal];
        await context.read<HymnProvider>().loadHymns(selectedHymnal.language);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //variable to hold the hymnal provider hymnal list
    final hymnalProvider = context.watch<HymnalProvider>();
    //varibal to hold the hymn provider
    final hymnProvider = context.watch<HymnProvider>();
    return Scaffold(
      drawer: NahDrawer(),
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(
            title: hymnalProvider.getHymnTitle(),
            leading: Builder(
              builder: (context) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: IconButton(
                    onPressed: () => handleDrawerButton(context),
                    icon: Icon(Icons.menu),
                  ),
                );
              },
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
          //Since all is dependent on the hymnal provider, show the progress indicator if hymnals or hymns are loading
          hymnalProvider.isLoading || hymnProvider.isLoading
              ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(
                    key: ValueKey('hymnScreenProgressIndicator'),
                  ),
                ),
              )
              : hymnalProvider.errorMessage != null &&
                  hymnalProvider.errorMessage!.isNotEmpty
              ? SliverFillRemaining(
                hasScrollBody: false,
                child: ErroMessageWithRetry(),
              )
              : SliverHymnList(
                hymns: hymnProvider.hymnList,
                isBookmarked: false,
              ),
        ],
      ),
    );
  }

  void handleDrawerButton(BuildContext context) {
    Scaffold.of(context).isDrawerOpen
        ? Scaffold.of(context).closeDrawer()
        : Scaffold.of(context).openDrawer();
  }
}
