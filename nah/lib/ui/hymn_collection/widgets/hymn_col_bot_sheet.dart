import 'package:flutter/material.dart';
import 'package:nah/data/models/bookmark_model.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/bookmarked_hymn/view_model/bookmarked_hymns_provider.dart';
import 'package:nah/ui/hymn_collection/widgets/create_hymn_collection_alert_dialog.dart';
import 'package:nah/ui/core/ui/modal_bot_sheet_container.dart';
import 'package:nah/ui/hymn_collection/view_model/hymn_collection_provider.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';
import 'package:provider/provider.dart';

class HymnColBotSheet extends StatelessWidget {
  const HymnColBotSheet({super.key, required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final hymnCollectionProvider = context.watch<HymnCollectionProvider>();
    return ModalBotSheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildColBotSheetTopBar(context, hymnCollectionProvider),
          Expanded(
            child:
                hymnCollectionProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hymnCollectionProvider.hymnCollections.isEmpty
                    ? _buildCollectionsEmpty()
                    : _buildColBotSheetList(hymnCollectionProvider),
          ),
        ],
      ),
    );
  }

  ///Method to build the hymn collection bottom sheet top bar
  Widget _buildColBotSheetTopBar(
    BuildContext context,
    HymnCollectionProvider hymnCollectionProvider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.modalBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () async {
          final newHymnCollection = await showDialog(
            context: context,
            builder: (context) => const CreateHymnCollectionAlertDialog(),
          );
          if (newHymnCollection != null) {
            final isAlreadyCreated = hymnCollectionProvider.hymnCollections.any(
              (collection) =>
                  collection.title.toLowerCase() ==
                  newHymnCollection.title.toLowerCase(),
            );
            if (!isAlreadyCreated) {
              await hymnCollectionProvider.createHymnCollection(
                newHymnCollection,
              );
            }
          }
        },

        child: const Text.rich(
          TextSpan(
            text: '+ ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            children: [
              TextSpan(
                text: 'Create New Collection',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionsEmpty() {
    return const Center(
      child: Text.rich(
        style: TextStyle(fontSize: 16),

        TextSpan(
          text: 'You currently don\'t have any collections\nClick ',
          children: [
            TextSpan(
              text: '+ create new collection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' to create a new one'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  ///Method to build a list of hymn collections
  Widget _buildColBotSheetList(HymnCollectionProvider hymnCollectionProvider) {
    return ListView.builder(
      itemCount: hymnCollectionProvider.hymnCollections.length,
      itemBuilder: (context, index) {
        ///Variable to store the list of hymn collections
        final hymnCollections =
            hymnCollectionProvider.hymnCollections.reversed.toList();

        ///Variable to store a particular hymn collection depending on its index
        final hymnCollection = hymnCollections[index];

        ///variable to hold the bookmarked hymns
        final bookmarks = context.watch<BookmarkedHymnsProvider>().bookmarks;

        ///variable below stores the current selected hymnal
        final selectedHymnal =
            context.read<HymnalProvider>().getSelectedHymnal();

        ///varibale to hold a bookmarked hymn
        final bookmarkedHymn = Bookmark(
          id: hymn.id,
          title: hymn.title,
          language: selectedHymnal.language,
          hymnColTitle: hymnCollection.title,
        );

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CheckboxListTile(
            tileColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.2),
            title: Text('${index + 1}. ${hymnCollection.title}'),

            ///return true if a hymn has been bookmarked in a particular collection
            value: bookmarks.any(
              (bookmark) =>
                  bookmark.id == bookmarkedHymn.id &&
                  bookmark.hymnColTitle == bookmarkedHymn.hymnColTitle,
            ),

            ///method that when a user checks or unchecks the checkbox, the hymn is added/ removed from the collection
            onChanged: (newValue) {
              ///checking that newValue is not null
              if (newValue == null) return;

              ///variable below stores the current selected hymnal
              final selectedHymnal =
                  context.read<HymnalProvider>().getSelectedHymnal();
              context.read<BookmarkedHymnsProvider>().toggleCollectionCheckBox(
                hymnId: hymn.id,
                hymnTitle: hymn.title,
                hymnalTitle: selectedHymnal.title,
                hymnalLang: selectedHymnal.language,
                hymnColTitle: hymnCollection.title,
              );
            },
          ),
        );
      },
    );
  }
}
