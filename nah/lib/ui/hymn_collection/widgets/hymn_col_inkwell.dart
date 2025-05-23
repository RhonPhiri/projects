import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_collection_model.dart';
import 'package:nah/ui/bookmarked_hymn/view_model/bookmarked_hymns_provider.dart';
import 'package:nah/ui/bookmarked_hymn/widgets/bookmarked_hymn_screen.dart';
import 'package:nah/ui/hymn_collection/view_model/hymn_collection_provider.dart';
import 'package:provider/provider.dart';

class HymnColInkwellButton extends StatelessWidget {
  const HymnColInkwellButton({
    super.key,
    required this.hymnCollections,
    required this.hymnCollectionsToDelete,
    required this.collection,
    required this.index,
  });
  final List<HymnCollection> hymnCollections;
  final List<HymnCollection> hymnCollectionsToDelete;
  final HymnCollection collection;
  final int index;

  @override
  Widget build(BuildContext context) {
    ///parameter values for the text properties in the collection item
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    ///color for checkboxes, iconButtons
    final color = Theme.of(
      context,
    ).colorScheme.onPrimary.withValues(alpha: 0.6);
    return InkWell(
      onTap: () async {
        ///assing the collection to the provider
        ///load the bookmarked hymns into the bookmarkedHymns list
        await context
            .read<BookmarkedHymnsProvider>()
            .loadBookmarkedHymnsForCollection(collection);

        ///Move to the bookMarkedHymn page

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookmarkedHymnScreen(collection: collection),
          ),
        );
      },

      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///Row to hold the index and title
            Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Row(
                    children: [Text('${index + 1}. ', style: textStyle)],
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
                  child: Consumer<BookmarkedHymnsProvider>(
                    builder: (context, bookmarkProvider, child) {
                      final totalBookmarks =
                          bookmarkProvider.bookmarks
                              .where(
                                (bookmark) =>
                                    bookmark.hymnColTitle == collection.title,
                              )
                              .toList()
                              .length
                              .toString();
                      return Text(totalBookmarks);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Checkbox(
                  semanticLabel: 'Select collection',
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: color, width: 2),
                  value: hymnCollectionsToDelete.contains(collection),
                  onChanged: (newValue) {
                    ///add a collection to the hymnCollectionToDel
                    if (newValue != null) {
                      context
                          .read<HymnCollectionProvider>()
                          .deOrSelectCollection(collection, newValue);
                    }
                  },
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(0),
                  tooltip: 'Delete Collection',
                  onPressed: () {
                    ///delete bookmarked hymns in that collection
                    context.read<BookmarkedHymnsProvider>().deleteBookmarks(
                      collection,
                    );

                    ///delete a single collection
                    context.read<HymnCollectionProvider>().deleteCollections(
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
  }

  ///Shows a snackbar when a collection is deleted
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
