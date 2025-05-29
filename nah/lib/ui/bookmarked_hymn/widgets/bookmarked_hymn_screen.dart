import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_collection_model.dart';
import 'package:nah/ui/bookmarked_hymn/view_model/bookmarked_hymns_provider.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/core/ui/sliver_hymn_list.dart';
import 'package:nah/ui/core/ui/sliver_list_empty.dart';
import 'package:provider/provider.dart';

class BookmarkedHymnScreen extends StatelessWidget {
  const BookmarkedHymnScreen({super.key, required this.collection});
  final HymnCollection collection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(
            title: collection.title,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title:
                              collection.description ==
                                      'No description available'
                                  ? null
                                  : const Text('Description'),
                          content: Text(collection.description),
                          contentTextStyle: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                  );
                },
                tooltip: 'Collection description',
                icon: const Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
          Consumer<BookmarkedHymnsProvider>(
            builder: (context, bookmarkProvider, child) {
              return bookmarkProvider.isLoading
                  ? SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        key: ValueKey("bhScreenLoading"),
                      ),
                    ),
                  )
                  : bookmarkProvider.bookmarkedHymns.isEmpty
                  ? SliverListEmpty(
                    message: "${collection.title} is empty",
                    emptyGender: "male",
                  )
                  : SliverHymnList(hymns: bookmarkProvider.bookmarkedHymns);
            },
          ),
        ],
      ),
    );
  }
}
