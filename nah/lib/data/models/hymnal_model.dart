import 'dart:convert';

class Hymnal {
  final int id;
  final String language;
  final String title;

  Hymnal({required this.id, required this.language, required this.title});

  Hymnal copyWith({int? id, String? language, String? title}) {
    return Hymnal(
      id: id ?? this.id,
      language: language ?? this.language,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'language': language, 'title': title};
  }

  factory Hymnal.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {'id': int id, 'language': String language, 'title': String title} =>
        Hymnal(id: id, language: language, title: title),
      _ => throw FormatException('Hymnal format not recognized'),
    };
  }

  String toJson() => json.encode(toMap());

  factory Hymnal.fromJson(String source) => Hymnal.fromMap(json.decode(source));

  @override
  String toString() => 'Hymnal(id: $id, language: $language, title: $title)';

  @override
  // Overrides the equality operator to compare two Hymnal objects
  // based on their id, language, and title properties.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Hymnal &&
        other.id == id &&
        other.language == language &&
        other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ language.hashCode ^ title.hashCode;
}
