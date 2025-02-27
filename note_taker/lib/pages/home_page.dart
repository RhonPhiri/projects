import 'package:flutter/material.dart';
import 'package:note_taker/components/note_container.dart';
import 'package:note_taker/models/note_provider.dart';
import 'package:note_taker/pages/note_editor_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(elevation: 4, title: Text('Note Taker')),
      body:
          notesProvider.notes.isEmpty
              ? Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/emptynote.png',
                      fit: BoxFit.cover,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    Text(
                      'Your notes will appear \nhere',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: notesProvider.notes.length,
                itemBuilder: (context, index) {
                  final note = notesProvider.notes[index];
                  return NoteContainer(note: note);
                },
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New note',
        onPressed: () async {
          //a variable that will either return a result (a newNote) or not
          //after the page is popped
          final newNote = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => NoteEditorPage()));

          if (newNote != null) {
            notesProvider.addNote(newNote);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
