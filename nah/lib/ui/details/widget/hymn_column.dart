import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/ui/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HymnColumn extends StatelessWidget {
  const HymnColumn({super.key, required this.hymn});

  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    ///variable to hold the list of verses
    final verses = getHymnVerses();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(2, (int index) {
          return Text(
            index == 0 ? "${hymn.id}. ${hymn.title}" : hymn.otherDetails,

            style: TextStyle(
              height: 1.5,
              fontSize: index == 0 ? 24 : 16,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.w300,
            ),
          );
        }),
        const Divider(),
        const SizedBox(height: 16),
        ...List.generate(verses.length, (int index) {
          ///variable to hold the font size
          final fontSize = context.watch<ThemeProvider>().fontSize;

          ///if the index of the this list generated is 0 and the hymn has a chorus
          ///then retain a column with the 1st verse & a chorus else retain a column of verses only
          return index == 0 && getChorus().isNotEmpty
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(2, (int columnIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      columnIndex == 0 ? verses[index] : getChorus(),

                      style: TextStyle(
                        height: 1.5,
                        fontSize: columnIndex == 0 ? fontSize : (fontSize + 1),
                        fontWeight:
                            columnIndex == 0
                                ? FontWeight.normal
                                : FontWeight.w700,
                      ),
                    ),
                  );
                }),
              )
              : Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  verses[index],
                  style: TextStyle(height: 1.5, fontSize: fontSize),
                ),
              );
        }),
      ],
    );
  }

  ///method to get lyrics from verses and chorus and format them
  List<String> getHymnVerses() {
    final verses =
        hymn.lyrics['verses'] is List
            ? (hymn.lyrics['verses'] as List)
                .map((verse) => verse.toString())
                .toList()
            : <String>[];

    return verses;
  }

  ///method to get the chorus from the hymn lyrics
  String getChorus() {
    final chorus = hymn.lyrics['chorus'] as String? ?? '';
    return chorus;
  }
}
