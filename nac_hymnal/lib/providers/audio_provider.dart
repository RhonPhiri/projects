import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:nac_hymnal/models/models.dart';
import 'package:nac_hymnal/services/hymn_services.dart';

class AudioProvider with ChangeNotifier {
  AudioProvider() {
    //load the audio files
    if (_audioFiles.isEmpty) {
      loadAudioFiles();
    }
    //Listen for the completion of the audio
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      notifyListeners();
    });
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  //variable to store the current playing state
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  //property to show a circular progress indicator when the hymn audio file is loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //Initialization of the audioService handling the loading of audiofile
  final _audioService = AudioService();
  //variable to store the list of audiofiles present in the config.json file in assets/audios/
  List<AudioFile> _audioFiles = [];
  List<AudioFile> get audioFiles => List.unmodifiable(_audioFiles);

  //method to load audiofiles from the audioService and store them in the _audioFiles
  void loadAudioFiles() async {
    try {
      //load and store all audiofiles in the _audioFiles property
      final audios = await _audioService.loadAudioFiles();
      _audioFiles.clear();
      _audioFiles.addAll(audios);
      // _audioFiles.sort((a, b) => a.title.compareTo(b.title));
    } catch (e) {
      print('ERROR failed to load audio files from the audio service: $e');
    } finally {
      print('Audio files loaded!!!!!');
    }
  }

  //method to play the current hymn audio file
  Future<void> play({required String url}) async {
    //before playing the audio file, set _isLoading to true, so that a progress indicator is shown
    _isLoading = true;
    notifyListeners();
    try {
      //fetch the audio file
      await _audioPlayer.play(UrlSource(url));
      //set the isPlaying to true after fetching the audio file
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error playing audio: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to stop the current hymn audio file from playing
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    } on Exception catch (e) {
      debugPrint('Error stopping the auido: $e');
    }
  }

  //dispose method to clean up resources
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
