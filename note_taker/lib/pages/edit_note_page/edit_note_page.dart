//page to create new, view, update and/or delete an existing note
import 'package:flutter/material.dart';
import 'package:note_taker/models/note_class.dart';
import 'package:note_taker/providers/note_provider.dart';
import 'package:note_taker/providers/theme_provider.dart';
import 'package:note_taker/pages/home_page/components/app_bart_buttons/app_bar_buttons.dart';
import 'package:provider/provider.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({super.key, this.note});
  //a nullable variable to chack whether we are creating a new note or viewing an existing
  //note
  final Note? note;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    if (widget.note != null) {
      _titleController.text = widget.note?.title ?? 'Title';
      _contentController.text = widget.note?.content ?? 'Content';
    }
  }

  void _saveNote() {
    final newNote = Note(
      id:
          widget.note != null
              ? widget.note!.id
              : DateTime.now().microsecondsSinceEpoch,
      title: _titleController.text,
      content: _contentController.text,
      timeStamp: DateTime.now(),
    );
    Navigator.of(context).pop(newNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.note == null
              ? 'Note created successfully'
              : 'Note updated successfully',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
              floating: true,
              snap: true,
              scrolledUnderElevation: 0,
              actions: [
                MaterialButton(
                  color: colorScheme.onInverseSurface,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: _saveNote,
                  child: Text(
                    widget.note == null ? 'Save' : 'Update Note',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const ThemeButton(),
              ],
              actionsPadding: const EdgeInsets.only(right: 8),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    style: textTheme.displayLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 32),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  const Divider(),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return TextField(
                        controller: _contentController,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize:
                              context
                                  .watch<ThemeProvider>()
                                  .fontSize
                                  .toDouble(),
                          color: colorScheme.onSurface,
                        ),
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Content',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          widget.note == null
              ? null
              : FloatingActionButton(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(
                              'Delete note?',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: colorScheme.onSurface),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<NoteProvider>().removeNote(
                                    widget.note!.id,
                                  );
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Note deleted successfully',
                                      ),
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
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: colorScheme.onInverseSurface,
                child: const Icon(Icons.delete),
              ),
    );
  }
}
