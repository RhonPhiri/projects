import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_downloader/model/downloaded_item.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  //getter to access file system directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //method to access the full reference to the file
  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  //method to save data to disk inform of bytes
  //each file will be saved seperately and have its own name
  Future<File> saveFile(String fileName, List<int> bytes) async {
    final file = await _localFile(fileName);
    return file.writeAsBytes(bytes);
  }

  //method to get data from disk using the file name
  Future<Uint8List> loadFile(String fileName) async {
    try {
      final file = await _localFile(fileName);
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }
      return file.readAsBytes();
    } catch (e) {
      print('Failed to load file from disk: $e');
      return Uint8List(0);
    }
  }

  //save a list of downloaded items
  Future<File> saveDownloadedList(List<DownloadedItem> downloadedList) async {
    final file = await _localFile('downloadedFiles.json');
    final jsonData =
        downloadedList
            .map((downloadedItem) => downloadedItem.toJson())
            .toList();
    final jsonString = jsonEncode(jsonData);
    return file.writeAsString(jsonString);
  }

  //load a list of downloaded items
  Future<List<DownloadedItem>> loadDownloadedList() async {
    try {
      final file = await _localFile('downloadedFiles.json');
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData
          .map((jsonMap) => DownloadedItem.fromJson(jsonMap))
          .toList();
    } catch (e) {
      print("Error loading downloaded list: $e");
      return [];
    }
  }
}
