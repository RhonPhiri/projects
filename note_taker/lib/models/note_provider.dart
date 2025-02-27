import 'package:flutter/widgets.dart';
import 'package:note_taker/models/note_class.dart';
import 'package:note_taker/models/notes_storage.dart';

class NoteProvider with ChangeNotifier {
  //constructor to loadNotes upon app initialization
  NoteProvider() {
    loadNotesFromStorage();
  }

  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  //variable to access the notes storage class
  final NotesStorage _storage = NotesStorage();

  //method to load notes from notesStorage
  Future<void> loadNotesFromStorage() async {
    //async& await is used because loadNotes retains a future
    final loadedNotes = await _storage.loadNotes();
    _notes.clear();
    _notes.addAll(loadedNotes);
    notifyListeners();
  }

  //method to save current notes list to storage
  Future<void> _saveNotesToStorage() async {
    await _storage.saveNotes(_notes);
  }

  //method to add notes to the list
  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
    //save the updated list of notes to storage
    _saveNotesToStorage();
  }

  //method to update/ save a modified note
  void updateNote(Note updatedNote) {
    //obtain the index of the note in the notes list
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    //note: indexwhere will return -1 if noteId has not found a match
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
      _saveNotesToStorage();
    }
  }

  //method to delete a note
  void deleteNote(int noteId) {
    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
    _saveNotesToStorage();
  }
}
