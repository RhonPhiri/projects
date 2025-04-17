import 'package:flutter/material.dart';
import 'package:note_taker/pages/search_note_delegate.dart';
import '../../../../models/note_class.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key, required this.noteContainerTapped});
  final void Function(Note) noteContainerTapped;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        //a variable that return a response which may either be a note or is null
        //if a note is retained, then view that note
        final searchedNote = await showSearch(
          context: context,
          delegate: SearchNoteDelegate(),
        );
        if (searchedNote != null) {
          noteContainerTapped(searchedNote);
        }
      },
      icon: const Icon(Icons.search),
    );
  }
}
