//this is a class that manages the access and the process of reading & writing to the local
//disk
import 'dart:convert';
import 'dart:io';
import 'package:note_taker/models/note_class.dart';
import 'package:path_provider/path_provider.dart';

class NoteStorage {
  //getter to access the common directories
  Future<String> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      print('Error accessing local storage file directory: $e');
      throw Exception('Failed to access storage directory');
    }
  }

  //getter to access the full reference to the file
  Future<File> get _localNotes async {
    try {
      final path = await _localPath;
      return File('$path/notes.json');
    } catch (e) {
      print('Error accessing notes file: $e');
      throw Exception('Falied to access the notes file in storage');
    }
  }

  //method to save data to the local disk
  Future<File> saveNotes(List<Note> notes) async {
    try {
      final file = await _localNotes;
      //convert the list of notes into a list of maps
      final jsonMapList = notes.map((note) => note.toJsonMap()).toList();
      //convert the jsonMapList into jsonString
      final jsonString = jsonEncode(jsonMapList);
      //qrite to disk using file
      return file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving notes: $e');
      throw Exception('Failed to sace notes to storage');
    }
  }

  //method to load a list of notes from the disk
  Future<List<Note>> loadNotes() async {
    try {
      final file = await _localNotes;
      //check if the file exists
      if (!await file.exists()) {
        return [];
      }
      //get the json file from disk using file
      final jsonString = await file.readAsString();
      //convert the jsonString into a list of maps
      final List<dynamic> jsonData = jsonDecode(jsonString);
      //check if the contents in the list are maps of notes toJsonMap type and return
      //list of notes
      return jsonData.map((jsonMap) => Note.fromJson(jsonMap)).toList();
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }
}
