import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/erro_message_with_retry.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/core/ui/sliver_hymn_list.dart';
import 'package:nah/ui/hymn/widgets/drawer/nah_drawer.dart';
import 'package:nah/ui/hymn/widgets/search/search_hymn_delegate.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:nah/ui/hymnal/widgets/hymnal_screen.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:provider/provider.dart';

/// Main screen for displaying hymns and searching/selecting hymnals.
class HymnScreen extends StatefulWidget {
  const HymnScreen({super.key});

  @override
  State<HymnScreen> createState() => _HymnScreenState();
}

class _HymnScreenState extends State<HymnScreen> {
  @override
  void initState() {
    super.initState();
    // Defer the call to loadHymnals() until after the widget tree is built.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<HymnalProvider>().loadHymnals();

      // If the widget is mounted in the widget tree, run the following callbacks.
      if (!mounted) return;
      // After hymnals are loaded, load hymns for the selected hymnal.
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
    /// Get the hymnal provider hymnal list.
    final hymnalProvider = context.watch<HymnalProvider>();

    /// Get the hymn provider.
    final hymnProvider = context.watch<HymnProvider>();
    return SafeArea(
      child: Scaffold(
        drawer: NahDrawer(),
        body: CustomScrollView(
          slivers: [
            MySliverAppBar(
              // Get the title from the provider.
              title: hymnalProvider.getHymnTitle(),
              leading: Builder(
                builder: (context) {
                  // Menu icon button.
                  return IconButton(
                    onPressed: () => handleDrawerButton(context),
                    icon: Icon(Icons.menu),
                  );
                },
              ),
              actions: List.generate(2, (int index) {
                // Search icon as the first button in the actions list.
                final searchIconPressed = index == 0;
                return IconButton(
                  onPressed: () async {
                    // If it's the searchicon pressed, then show the search, else, navigate to hymnal screen.
                    searchIconPressed
                        ? showSearch(
                          context: context,
                          delegate: SearchHymnDelegate(searchHymnId: false),
                        )
                        : Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HymnalScreen(),
                          ),
                        );
                  },
                  icon: Icon(searchIconPressed ? Icons.search : Icons.book),
                );
              }),
            ),
            // Since all is dependent on the hymnal provider, show the progress indicator if hymnals or hymns are loading.
            hymnalProvider.isLoading || hymnProvider.isLoading
                ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    key: ValueKey('hymnScreenProgressIndicator'),
                    child: CircularProgressIndicator(),
                  ),
                )
                : hymnalProvider.errorMessage != null &&
                    hymnalProvider.errorMessage!.isNotEmpty
                ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErroMessageWithRetry(key: ValueKey('hymnError')),
                )
                : SliverHymnList(
                  key: ValueKey("sliverHymnList"),
                  hymns: hymnProvider.hymnList,
                ),
          ],
        ),
        // Search hymn number through the FAB.
        floatingActionButton: FloatingActionButton(
          key: ValueKey("searchHymnId"),
          onPressed:
              () => showSearch(
                context: context,
                delegate: SearchHymnDelegate(searchHymnId: true),
              ),
          child: Icon(Icons.dialpad),
        ),
      ),
    );
  }

  /// Method to handle the opening & closing of the drawer.
  void handleDrawerButton(BuildContext context) {
    Scaffold.of(context).isDrawerOpen
        ? Scaffold.of(context).closeDrawer()
        : Scaffold.of(context).openDrawer();
  }
}
