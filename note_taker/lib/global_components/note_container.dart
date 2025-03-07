import 'package:flutter/material.dart';
import 'package:note_taker/models/note_class.dart';
import 'package:note_taker/providers/note_provider.dart';
import 'package:note_taker/pages/edit_note_page/edit_note_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NoteContainer extends StatelessWidget {
  const NoteContainer({super.key, required this.note, this.onTap});
  final Note note;
  final void Function()? onTap;

  void noteContainerTapped(Note? note, BuildContext context) async {
    final notesProvider = context.read<NoteProvider>();
    final updatedNote = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => EditNotePage(note: note)));
    if (updatedNote != null) {
      notesProvider.updateNote(updatedNote);
    }
  }

  String formatedDate(DateTime timeStamp) {
    final formatter = DateFormat.Hm().add_yMMMEd();
    return formatter.format(timeStamp);
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NoteProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      onLongPress:
          () => showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(
                    'Delete note?',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        notesProvider.removeNote(note.id);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Note deleted successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
          ),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surfaceContainerHigh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToLastDescent: false,
              ),
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Text(
              note.content,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),

            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatedDate(note.timeStamp),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
