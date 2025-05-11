import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_collection_model.dart';
import 'package:nah/ui/hymn_collection/view_model/hymn_collection_provider.dart';
import 'package:provider/provider.dart';

class HymnColScreenTopBar extends StatelessWidget {
  const HymnColScreenTopBar({
    super.key,
    required this.color,
    required this.hymnCollectionsToDel,
    required this.hymnCollections,
  });
  final Color color;
  final List<HymnCollection> hymnCollectionsToDel;
  final List<HymnCollection> hymnCollections;

  @override
  Widget build(BuildContext context) {
    final hymnCollectionProvider = context.watch<HymnCollectionProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Checkbox(
            side: BorderSide(color: color, width: 2),
            semanticLabel: 'Select all',
            //check if the length of the hymnCollections == hymncollections to be deleted. length
            value: hymnCollectionsToDel.length == hymnCollections.length,

            onChanged: (newValue) {
              if (newValue != null) {
                hymnCollectionProvider.deOrSelectAll(selectall: newValue);
              }
            },
          ),
          IconButton(
            onPressed: () {
              //Delete all collections in the hymnCollectionsToDel
              _buildSnackBar(context, 2);
              context.read<HymnCollectionProvider>().deleteCollections();
            },
            tooltip: 'Delete selected',
            icon: Icon(Icons.delete, color: color),
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
