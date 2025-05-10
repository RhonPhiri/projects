import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
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
                hymnCollectionProvider.hymnCollections.isEmpty
                    ? _buildCollectionsEmpty()
                    : _buildColBotSheetList(hymnCollectionProvider),
          ),
        ],
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
              hymnCollectionProvider.createHymnCollection(newHymnCollection);
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
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColBotSheetList(HymnCollectionProvider hymnCollectionProvider) {
    return ListView.builder(
      itemCount: hymnCollectionProvider.hymnCollections.length,
      itemBuilder: (context, index) {
        final collection = hymnCollectionProvider.hymnCollections[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CheckboxListTile(
            tileColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            title: Text('${index + 1}. ${collection.title}'),

            //return true if this collection contains this hymn
            value: collection.hymnList.any(
              (bookmarkedHymn) => bookmarkedHymn.title == hymn.title,
            ),
            //method that when a user checks or unchecks the checkbox, the hymn is added/ removed
            // from the collection
            onChanged: (newValue) {
              //checking that newValue is not null
              if (newValue == null) return;
              //variable below stores the current selected hymnal
              final selectedHymnal =
                  context.read<HymnalProvider>().getSelectedHymnal();

              context.read<HymnCollectionProvider>().toggleCollectionCheckBox(
                newValue: newValue,
                collection: collection,
                newHymn: hymn,
                hymnal: selectedHymnal,
              );
              final bottomMargin = MediaQuery.of(context).size.height / 2 + 50;
              //Show a snackbar to show successfull addition or removal of a hymn from a collection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  dismissDirection: DismissDirection.down,
                  margin: EdgeInsets.only(
                    bottom: bottomMargin,
                    left: 24,
                    right: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(milliseconds: 1300),
                  content: Text(
                    newValue
                        ? 'Hymn added to ${collection.title} successfully'
                        : 'Hymn removed from ${collection.title} successfully',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
