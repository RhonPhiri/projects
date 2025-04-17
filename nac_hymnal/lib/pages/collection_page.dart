import 'package:flutter/material.dart';
import 'package:nac_hymnal/components/my_sliver_app_bar.dart';
import 'package:nac_hymnal/components/sliver_list_empty.dart';
import 'package:nac_hymnal/pages/bookmarked_hymns_page.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = 'Collection';
    final hymnCollectionProvider = context.watch<HymnCollectionProvider>();
    //color for checkboxes, iconButtons
    final color = Theme.of(
      context,
    ).colorScheme.onPrimary.withValues(alpha: 0.6);
    final hymnCollections = hymnCollectionProvider.hymnCollections;
    final hymnCollectionsToDel = hymnCollectionProvider.hymnCollectionsToDel;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(title: title),
          SliverToBoxAdapter(
            //if one has clicked a checkbox, then activate this row
            child:
                hymnCollectionsToDel.isNotEmpty
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            side: BorderSide(color: color, width: 2),
                            semanticLabel: 'Select all',
                            //check if the length of the hymnCollections == hymncollections to be deleted. length
                            value:
                                hymnCollectionsToDel.length ==
                                hymnCollections.length,

                            onChanged: (newValue) {
                              if (newValue != null) {
                                hymnCollectionProvider.deOrSelectAll(
                                  selectall: newValue,
                                );
                              }
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              //Delete all collections in the hymnCollectionsToDel
                              _buildSnackBar(context, 2);
                              context
                                  .read<HymnCollectionProvider>()
                                  .deleteCollections();
                            },
                            tooltip: 'Delete selected',
                            icon: Icon(Icons.delete, color: color),
                          ),
                        ],
                      ),
                    )
                    : const SizedBox(height: 16),
          ),

          //Allow to de/select all collections or nothing
          const SliverToBoxAdapter(),
          hymnCollections.isEmpty
              ? const SliverListEmpty(
                message: 'You currently don\'t have any collections',
              )
              : SliverList.separated(
                itemCount: hymnCollections.length,
                itemBuilder: (context, index) {
                  final collection = hymnCollections[index];
                  //parameter values for the text properties in the collection item
                  final textStyle = Theme.of(context).textTheme.bodyLarge;
                  return InkWell(
                    onTap: () {
                      //assing the collection to the provider
                      //load the bookmarked hymns into the bookmarkedHymns list
                      context.read<BookmarkedHymnsProvider>().updateCollection(
                        collection: collection,
                      );
                      //Move to the bookMarkedHymn page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  BookmarkedHymnsPage(collection: collection),
                        ),
                      );
                    },

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Row to hold the index and title
                          Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Row(
                                  children: [
                                    Text('${index + 1}. ', style: textStyle),
                                  ],
                                ),
                              ),
                              Text(
                                collection.title,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: textStyle?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(127),
                                child: Text('${collection.hymnList.length}'),
                              ),
                              const SizedBox(width: 8),
                              Checkbox(
                                semanticLabel: 'Select collection',
                                visualDensity: VisualDensity.compact,
                                side: BorderSide(color: color, width: 2),
                                value: hymnCollectionsToDel.contains(
                                  collection,
                                ),
                                onChanged: (newValue) {
                                  //add a collection to the hymnCollectionToDel
                                  if (newValue != null) {
                                    context
                                        .read<HymnCollectionProvider>()
                                        .deOrSelectCollection(
                                          collection,
                                          newValue,
                                        );
                                  }
                                },
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.all(0),
                                tooltip: 'Delete Collection',
                                onPressed: () {
                                  //delete a single collection
                                  context
                                      .read<HymnCollectionProvider>()
                                      .deleteCollections(
                                        collection: collection,
                                      );
                                  _buildSnackBar(context, 1);
                                },
                                icon: Icon(Icons.delete, color: color),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder:
                    (context, index) => Container(
                      height: 1,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                    ),
              ),
        ],
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _buildSnackBar(
    BuildContext context,
    int numberOfCollections,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        content: Text(
          'Collection${numberOfCollections == 1 ? '' : 's'} deleted successfully',
        ),
      ),
    );
  }
}
