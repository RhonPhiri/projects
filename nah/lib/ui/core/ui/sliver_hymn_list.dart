import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/core/ui/open_container_transition.dart';
import 'package:nah/ui/details/widget/details_screen.dart';

class SliverHymnList extends StatelessWidget {
  const SliverHymnList({super.key, required this.hymns});
  final List<Hymn> hymns;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 8),
      sliver: SliverList.separated(
        itemCount: hymns.length,
        itemBuilder: (context, index) {
          final hymn = hymns[index];
          return OpenContainerTransition(
            key: ValueKey('hymnOpenContainer_${hymn.id}'),
            closedBuilderWidget: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
              child: Text(
                '${hymn.id}. ${hymn.title}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            openBuilderWidget: DetailsScreen(hymn: hymn, isBookmarked: false),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
