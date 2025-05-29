import 'package:flutter/material.dart';
import 'package:nah/ui/core/ui/no_data.dart';
import 'package:nah/ui/core/ui/sliver_hymn_list.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:provider/provider.dart';

class SearchHymnDelegate extends SearchDelegate {
  ///property to hold the current index based on the search IconButton tapped in the
  ///appBar actions
  final bool searchHymnId;

  SearchHymnDelegate({
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    super.autocorrect,
    super.enableSuggestions,
    required this.searchHymnId,
  });

  ///I have overriden the label to display a custom one
  @override
  String? get searchFieldLabel =>
      'Search hymn ${searchHymnId ? 'number' : 'title, lyrics'}';

  ///I have also overriden the keyboardType to show a number keyborad if searchHymnId is true
  ///else, return a text keyboard
  @override
  TextInputType? get keyboardType =>
      searchHymnId
          ? const TextInputType.numberWithOptions(decimal: false)
          : TextInputType.text;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
        tooltip: 'Clear querry',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return filteredHymnSliverList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return filteredHymnSliverList(context);
  }

  ///Filters the list of hymns based on the search query
  Widget filteredHymnSliverList(BuildContext context) {
    final hymns = context.watch<HymnProvider>().hymnList;

    ///
    ///method to filter the list of hymns based on the contents containing the query
    ///need to check that the "verses" key is present or not hence List<dynamic>?
    ///if not null then map the list of verses and retain them as a List strings or else retain an empty <String>[]
    ///
    ///Also check if the key chorus exists or is null
    ///if null, then retain them as strings
    final filteredHymns =
        hymns.where((hymn) {
          ///conscise way of writing this
          // final verses =
          //     (hymn.lyrics['verses'] as List<dynamic>?)?.map(
          //       (verse) => verse.toString(),
          //     ) ??
          //     [];
          ///another way of writing this
          final verses =
              hymn.lyrics['verses'] is List
                  ? (hymn.lyrics['verses'] as List)
                      .map((verse) => verse.toString())
                      .toList()
                  : <String>[];

          ///first way of getting the string
          // final chorus = hymn.lyrics['chorus']?.toString() ?? '';
          ///another way
          final chorus = hymn.lyrics['chorus'] as String? ?? '';
          final lowerCaseQuery = query.toLowerCase();

          ///if searchHymnId is true then search for the id else search for the
          ///title or lyrics
          return searchHymnId
              ? hymn.id.toString().startsWith(lowerCaseQuery)
              : hymn.title.toLowerCase().contains(lowerCaseQuery) ||
                  verses.any(
                    (verse) => verse.toLowerCase().contains(lowerCaseQuery),
                  ) ||
                  chorus.toLowerCase().contains(lowerCaseQuery);
        }).toList();

    return filteredHymns.isEmpty
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('No Hymns found', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 8),
            NoData(gender: "female"),
          ],
        )
        : CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverHymnList(hymns: filteredHymns),
          ],
        );
  }
}
