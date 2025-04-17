import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nac_hymnal/models/audio_file_model.dart';

class AudioService {
  //method to load audio json file from the assets and parse the contents using the from json method
  Future<List<AudioFile>> loadAudioFiles() async {
    try {
      //TODO: replace with loading from a dytabase
      final audioJsonFile = await rootBundle.loadString(
        "assets/audios/config.json",
      );
      //decode the json into a list<dynamic> file
      final List<dynamic> audioData = jsonDecode(audioJsonFile);
      //parse the data in the from json method
      return audioData
          .map((audioFile) => AudioFile.fromJson(audioFile))
          .toList();
    } catch (e) {
      print('Error loading audio files from assets/audios/: $e');
      return <AudioFile>[];
    }
  }
}
