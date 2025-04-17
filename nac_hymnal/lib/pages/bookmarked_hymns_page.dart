import 'package:flutter/material.dart';
import 'package:nac_hymnal/components/my_sliver_app_bar.dart';
import 'package:nac_hymnal/components/sliver_hymn_list.dart';
import 'package:nac_hymnal/components/sliver_list_empty.dart';
import 'package:nac_hymnal/models/models.dart';
import 'package:nac_hymnal/providers/bookmarked_hymns_provider.dart';
import 'package:provider/provider.dart';

class BookmarkedHymnsPage extends StatelessWidget {
  const BookmarkedHymnsPage({super.key, required this.collection});
  final HymnCollection collection;

  @override
  Widget build(BuildContext context) {
    final hymnList = context.watch<BookmarkedHymnsProvider>().bookmarkedHymns;

    final hymnals = hymnList.map((bh) => bh.hymnal).toList();
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
                          contentTextStyle: TextStyle(
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
          collection.hymnList.isEmpty
              ? const SliverListEmpty(
                message: 'No hymns were added into this collection',
              )
              : SliverHymnList(
                hymns: hymnList,
                isBookmarked: true,
                hymnals: hymnals,
              ),
        ],
      ),
    );
  }
}
