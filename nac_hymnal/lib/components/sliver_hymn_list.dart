import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:nac_hymnal/hymn/hymn_model.dart';
import 'package:nac_hymnal/models/hymnal_model.dart';
import 'package:nac_hymnal/pages/details_page.dart';

class SliverHymnList extends StatelessWidget {
  const SliverHymnList({
    super.key,
    required this.hymns,
    required this.isBookmarked,
    this.hymnals,
  });
  final List<Hymn> hymns;
  //This variable holds the bool to indicate if the hymn list are bookmarks or not
  final bool isBookmarked;
  //if isBookmark, the hymnal list below will be provided, otherwise is nullable
  //this list is receiving hymnals that can be null themselves due to the selectedHymnal
  //getter in the hymnal collection provider
  final List<Hymnal?>? hymnals;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: hymns.length,
      itemBuilder: (context, index) {
        final hymn = hymns[index];
        return OpenContainer(
          closedElevation: 0,
          closedColor: Theme.of(context).colorScheme.surface,
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: ContainerTransitionType.fadeThrough,
          closedBuilder: (context, action) {
            return isBookmarked
                ? ListTile(
                  contentPadding: const EdgeInsets.only(left: 16),
                  title: Text(
                    '${index + 1}. ${hymn.title}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '${hymnals?[index]?.title ?? "Unknown"}, No: ${hymn.id}',
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Text(
                    '${hymn.id}. ${hymn.title}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
          },
          openBuilder: (context, action) {
            return DetailsPage(hymn: hymn, isBookmark: isBookmarked);
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
