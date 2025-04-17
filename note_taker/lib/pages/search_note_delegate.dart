import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_taker/global_components/note_container.dart';
import 'package:note_taker/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchNoteDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;
    final filteredNotes = notes.where(
      (note) =>
          note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase()),
    );
    return filteredNotes.isEmpty
        ? Center(
          child: Text(
            'No data!',
            textAlign: TextAlign.center,
            style: GoogleFonts.alexBrush(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        : StaggeredGridView.countBuilder(
          crossAxisCount: 2,

          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            return filteredNotes
                .map<NoteContainer>(
                  (note) => NoteContainer(
                    note: note,
                    onTap: () => close(context, note),
                  ),
                )
                .toList()[index];
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;
    final filteredNotes = notes.where((note) {
      final noteContent = '${note.title}+${note.content}';
      return noteContent.toLowerCase().contains(query.toLowerCase());
    });
    return filteredNotes.isEmpty
        ? Center(
          child: Text(
            'No data!',
            textAlign: TextAlign.center,
            style: GoogleFonts.alexBrush(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        : StaggeredGridView.countBuilder(
          crossAxisCount: 2,

          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            return filteredNotes
                .map<NoteContainer>(
                  (note) => NoteContainer(
                    note: note,
                    onTap: () => close(context, note),
                  ),
                )
                .toList()[index];
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
        );
  }
}
