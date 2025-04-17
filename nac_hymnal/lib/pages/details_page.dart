import 'package:flutter/material.dart';
import 'package:nac_hymnal/components/hymn_col_bot_sheet.dart';
import 'package:nac_hymnal/components/settings_modal_bot_sheet.dart';
import 'package:nac_hymnal/hymn/hymn_model.dart';
import 'package:nac_hymnal/providers/audio_provider.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.hymn, required this.isBookmark});
  final Hymn hymn;
  final bool isBookmark;

  //method to get lyrics from verses and chorus and format them
  List<String> getHymnVerses() {
    final verses =
        hymn.lyrics['verses'] is List
            ? (hymn.lyrics['verses'] as List)
                .map((verse) => verse.toString())
                .toList()
            : <String>[];

    return verses;
  }

  //method to get the chorus from the hymn lyrics
  String getChorus() {
    final chorus = hymn.lyrics['chorus'] as String? ?? '';
    return chorus;
  }

  @override
  Widget build(BuildContext context) {
    //variable to hold the list of verses
    final verses = getHymnVerses();
    //variable to hold the list of names of the actions buttons for the appbar
    final actionButtonLable = ['Preferences', 'Bookmark'];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  if (isBookmark) {
                    context.read<BookmarkedHymnsProvider>().updateCollection();
                  }
                  if (context.read<AudioProvider>().isPlaying) {
                    context.read<AudioProvider>().stop();
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              //generate a list of iconButtons for the actions based on the actionButtonLable
              actions: [
                ...List.generate(actionButtonLable.length, (int actionIndex) {
                  //variable to hold the lables of the iconbuttons for the actions
                  final actionLabel = actionButtonLable[actionIndex];
                  return IconButton(
                    onPressed: () {
                      //variable below stores the current selected hymnal
                      final selectedHymnal =
                          context.read<HymnalProvider>().selectedHymnal;
                      // load hymnals if the selectedhymnal is null
                      if (actionLabel == 'Bookmark' && selectedHymnal == null) {
                        context.read<HymnalProvider>().loadHymnals();
                      }
                      showModalBottomSheet(
                        context: context,
                        builder:
                            (context) =>
                                actionLabel == 'Preferences'
                                    ? SettingsModalBotSheet(hymn: hymn)
                                    : HymnColBotSheet(hymn: hymn),
                      );
                    },
                    tooltip: actionLabel,
                    icon: Icon(
                      actionLabel == 'Preferences'
                          ? Icons.settings
                          : Icons.bookmark_add_rounded,
                    ),
                  );
                }),
                Consumer<AudioProvider>(
                  builder: (context, value, child) {
                    //variable to hold the indices of the text to be extracted from otherDetails
                    final start = 0;
                    final end = hymn.otherDetails.indexOf('\n');
                    //Extracting the number of the hymn in a reference hymnal. It is located at the start of otherDetails
                    final extractedText = hymn.otherDetails.substring(
                      start,
                      end,
                    );
                    //property to hold the bool if a audioFile title is contained as part of the title/ otherDetails
                    //if this hymn has an audiofile, its index is retained, otherwise, -1 is retained
                    final audioFileIndex = value.audioFiles.indexWhere(
                      (audioFile) => audioFile.audioId == extractedText,
                    );
                    //return the play icon button if an audioFile matches with the title/ part of the content
                    // of other details
                    return audioFileIndex == -1
                        ? SizedBox.shrink()
                        : value.isLoading
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : IconButton(
                          onPressed: () {
                            value.isPlaying
                                ? value.stop()
                                : value.play(
                                  url: value.audioFiles[audioFileIndex].url,
                                );
                          },
                          icon: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        );
                  },
                ),
              ],

              actionsPadding: const EdgeInsets.only(right: 16),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(2, (int index) {
                      return Text(
                        index == 0
                            ? "${hymn.id}. ${hymn.title}"
                            : hymn.otherDetails,

                        style: TextStyle(
                          height: 1.5,
                          fontSize: index == 0 ? 24 : 16,
                          fontWeight:
                              index == 0 ? FontWeight.bold : FontWeight.w300,
                        ),
                      );
                    }),
                    const Divider(),
                    const SizedBox(height: 16),
                    ...List.generate(verses.length, (int index) {
                      final fontSize = context.watch<ThemeProvider>().fontSize;
                      //if the index of the this list generated is 0 and the hymn has a chorus
                      //then retain a column with the 1st verse & a chorus else retain a column of verses only
                      return index == 0 && getChorus().isNotEmpty
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(2, (int columnIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  columnIndex == 0
                                      ? verses[index]
                                      : getChorus(),

                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize:
                                        columnIndex == 0
                                            ? fontSize
                                            : (fontSize + 1),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
