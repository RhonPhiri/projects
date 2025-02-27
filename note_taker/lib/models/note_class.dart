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

  //method to convert data to a map that will later be converted to json
  Map<String, dynamic> jsonMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  //method to convert each map (jsonMap) to a note object
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
      _ => throw const FormatException('Unrecognised json format'),
    };
  }
  //the copywith method to copy of the original instance properties & values
  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? timeStamp,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  //the operator and hashcode method overrides for list management
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
