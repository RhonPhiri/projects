class AudioFile {
  final String audioId;
  final String url;

  AudioFile({required this.audioId, required this.url});

  factory AudioFile.fromJson(Map<String, dynamic> jsonMap) {
    return switch (jsonMap) {
      {"audioId": String title, "url": String url} => AudioFile(
        audioId: title,
        url: url,
      ),
      _ => throw UnimplementedError(),
    };
  }

  @override
  String toString() {
    return audioId;
  }
}
