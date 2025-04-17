import 'package:flutter/widgets.dart';
import 'package:note_taker/models/note_class.dart';
import 'package:note_taker/services/note_storage.dart';
import 'package:note_taker/pages/home_page/components/app_bart_buttons/app_bar_buttons.dart';

class NoteProvider with ChangeNotifier {
  //a private list of notes
  final List<Note> _notes = [];
  //
  //
  //A sort option to manage the sorting
  Sort sortOption = Sort.date;
  //getter to retrieve an unmordifiable list of notes
  List<Note> get notes => List.unmodifiable(_notes);

  //property to access the NotesStorage service
  final NoteStorage _storage = NoteStorage();
  //local variable to store an error message and its getter
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  //method to load notes from the disk. Has been called in the initstate by a homepage
  //local method
  Future<void> loadNotesFromDisk() async {
    try {
      _notes.clear();
      final loadedNotes = await _storage.loadNotes();
      _notes.addAll(loadedNotes);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Faled to load notes from storage';
      print('Error in provider: $e');
    }
  }

  //method to write notes to disk
  Future<void> _saveNotesToDisk() async {
    await _storage.saveNotes(_notes);
  }

  //method to add a note to the _notes list, save to local disk and notify listeners
  void addNote(Note newNote) {
    _notes.add(newNote);
    _saveNotesToDisk();
    notifyListeners();
  }

  //method to remove a note from the list, save current list and notify listeners
  void removeNote(int noteId) {
    final index = _notes.indexWhere((note) => note.id == noteId);
    _notes.removeAt(index);
    _saveNotesToDisk();
    notifyListeners();
  }

  //mthod to update a note, save to disk and notify listeners'
  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      _saveNotesToDisk();
      notifyListeners();
    }
  }

  //methods to sort the list of notes
  /*Failed to add the sort functionality to the notes getter since when sorting happens,
  the wigets are not notified that the list of notes has changed
  */
  void sortByName() {
    _notes.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void sortByDate() {
    _notes.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    notifyListeners();
  }

  void sortByContentSize() {
    _notes.sort(
      (a, b) =>
          b.content.characters.length.compareTo(a.content.characters.length),
    );
    notifyListeners();
  }
}
