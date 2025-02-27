import 'package:flutter/material.dart';
import 'package:note_taker/models/note_class.dart';
import 'package:note_taker/models/note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key, this.note});
  final Note? note;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final newNote = Note(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: titleController.text,
      content: contentController.text,
      timeStamp: DateTime.now(),
    );
    Navigator.of(context).pop(newNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1500),
        content: Text(
          'Note ${widget.note == null ? 'saved' : 'updated'} successfully',
        ),
      ),
    );
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<NoteProvider>().deleteNote(widget.note!.id);
                  Navigator.of(context).pop();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit note' : 'New note'),
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          //display a delete button if note is not null
          if (widget.note != null)
            IconButton(
              tooltip: 'Delete note',
              onPressed: () => _deleteNote(),
              icon: Icon(Icons.delete),
            ),
          MaterialButton(
            color: Theme.of(context).colorScheme.inversePrimary,
            onPressed: () {
              _saveNote();
            },
            child: Text(
              widget.note == null ? 'Save' : 'Update',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            maxLines: 2,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          Divider(),
          Expanded(
            child: TextField(
              controller: contentController,
              maxLines: null,
              expands: true,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Content',
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
