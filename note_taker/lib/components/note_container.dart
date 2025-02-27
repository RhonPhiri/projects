import 'package:flutter/material.dart';
import 'package:note_taker/models/note_class.dart';
import 'package:note_taker/models/note_provider.dart';
import 'package:note_taker/pages/note_editor_page.dart';
import 'package:provider/provider.dart';

class NoteContainer extends StatelessWidget {
  const NoteContainer({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.read<NoteProvider>();
    return GestureDetector(
      onTap: () async {
        final updatedNote = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NoteEditorPage(note: note)),
        );

        if (updatedNote != null) {
          notesProvider.updateNote(updatedNote);
        }
      },
      onLongPress:
          () => showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Are you sure you want to delete this note?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        notesProvider.deleteNote(note.id);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(milliseconds: 1500),
                            content: Text('Note deleted successfully'),
                          ),
                        );
                      },
                      child: Text('Yes', style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('No'),
                    ),
                  ],
                ),
          ),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.inversePrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(note.content, maxLines: 8, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
