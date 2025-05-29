import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/bookmarked_hymn/view_model/bookmarked_hymns_provider.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/details/widget/flow_menu/flow_menu.dart';
import 'package:nah/ui/details/widget/hymn_column.dart';
import 'package:provider/provider.dart';

/// Screen that displays the details of a single hymn.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
    required this.hymn,
    required this.isBookmarked,
  });
  final Hymn hymn;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    ///Variable to access the bookmarked hymn provider
    final bookamrkProvider = context.watch<BookmarkedHymnsProvider>();
    final bookmarkCondition = (isBookmarked && bookamrkProvider.isLoading);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// App bar for the details screen.
          // SliverAppBar(key: ValueKey("DetailsScreenSliverAppBar")),
          MySliverAppBar(
            title: bookmarkCondition ? "" : "${hymn.id}. ${hymn.title}",
          ),

          /// Main content: hymn details.
          bookmarkCondition
              ? SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
              : SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HymnColumn(hymn: hymn),
                ),
              ),
        ],
      ),

      /// Floating action button menu for actions related to the hymn.
      floatingActionButton: FlowMenu(hymn: hymn),
    );
  }
}
