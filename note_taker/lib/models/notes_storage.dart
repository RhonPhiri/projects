import 'dart:convert';
import 'dart:io';

import 'package:note_taker/models/note_class.dart';
import 'package:path_provider/path_provider.dart';

class NotesStorage {
  //getter to access the file system directories
  //these are private methods
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //getter to get full reference to the local directory
  Future<File> get _notesFile async {
    final path = await _localPath;
    return File('$path/notes.json');
  }

  //method to save notes to the disk inform of a json file
  //these are public methods
  Future<File> saveNotes(List<Note> notes) async {
    final file = await _notesFile;
    //convert each note into a jsonMap list
    final jsonData = notes.map((note) => note.jsonMap()).toList();
    //convert the list of jsonMaps into a jsonString
    final jsonString = jsonEncode(jsonData);
    //save the jsonString into the file path
    return file.writeAsString(jsonString);
  }

  //method to load a json file from disk and return a list of notes from it
  Future<List<Note>> loadNotes() async {
    //try to fetch the file
    try {
      final file = await _notesFile;
      //check if the file exists
      if (!await file.exists()) {
        return [];
      }
      //fetch the json file
      final jsonString = await file.readAsString();
      //convert the jsonString into the list of jsonMaps
      final List<dynamic> jsonData = jsonDecode(jsonString);
      //check the content of each jsonMap with the from json method and return a List of notes
      return jsonData.map((jsonMap) => Note.fromJson(jsonMap)).toList();
    } catch (e) {
      //if there's an error, return an empty list
      //TODO: add error handling implementation other than an empty list
      return [];
    }
  }
}
