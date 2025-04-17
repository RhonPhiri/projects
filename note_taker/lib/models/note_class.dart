class Note {
  final int id;
  final String title;
  final String content;
  final DateTime timeStamp;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.timeStamp,
  });

  //method to convert a note into a map
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  //method to convert each jsonMap object into a note
  factory Note.fromJson(Map<String, dynamic> jsonMap) {
    return switch (jsonMap) {
      {
        'id': int id,
        'title': String title,
        'content': String content,
        'timeStamp': String timeStamp,
      } =>
        Note(
          id: id,
          title: title,
          content: content,
          timeStamp: DateTime.parse(timeStamp),
        ),
      _ => throw const FormatException('The json format is not recognised'),
    };
  }

  //the operator & hashcode override to define what one note object deffers from the other
  @override
  bool operator ==(Object other) {
    if (identical(Note, other)) return true;
    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ content.hashCode ^ timeStamp.hashCode;
  }
}
