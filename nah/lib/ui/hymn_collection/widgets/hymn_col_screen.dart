import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/my_sliver_app_bar.dart';
import 'package:nah/ui/core/ui/sliver_list_empty.dart';
import 'package:nah/ui/hymn_collection/view_model/hymn_collection_provider.dart';
import 'package:nah/ui/hymn_collection/widgets/hymn_col_inkwell.dart';
import 'package:nah/ui/hymn_collection/widgets/hymn_col_screen_top_bar.dart';
import 'package:provider/provider.dart';

class HymnColScreen extends StatelessWidget {
  const HymnColScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final title = 'Collection';
    final hymnCollectionProvider = context.watch<HymnCollectionProvider>();
    final hymnCollections = hymnCollectionProvider.hymnCollections;
    final hymnCollectionsToDel = hymnCollectionProvider.hymnCollectionsToDel;
    //color for checkboxes, iconButtons
    final color = Theme.of(
      context,
    ).colorScheme.onPrimary.withValues(alpha: 0.6);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MySliverAppBar(title: title),
          SliverToBoxAdapter(
            //if one has clicked a checkbox, then activate this row, a top bar
            child:
                hymnCollectionsToDel.isNotEmpty
                    ? HymnColScreenTopBar(
                      color: color,
                      hymnCollectionsToDel: hymnCollectionsToDel,
                      hymnCollections: hymnCollections,
                    )
                    : const SizedBox(height: 16),
          ),

          //Allow to de/select all collections or nothing
          const SliverToBoxAdapter(),
          hymnCollections.isEmpty
              ? SliverListEmpty(
                message: 'You currently don\'t have any hymn collections',
              )
              : SliverList.separated(
                itemCount: hymnCollections.length,
                itemBuilder: (context, index) {
                  final collection = hymnCollections[index];

                  return HymnColInkwellButton(
                    hymnCollections: hymnCollections,
                    hymnCollectionsToDelete: hymnCollectionsToDel,
                    collection: collection,
                    index: index,
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
}
