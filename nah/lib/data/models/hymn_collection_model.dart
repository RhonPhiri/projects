import 'dart:convert';

class HymnCollection {
  final int? id;
  final String title;
  final String description;

  HymnCollection({this.id, required this.title, required this.description});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HymnCollection &&
        other.id == id &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ description.hashCode;
  }

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
  };

  factory HymnCollection.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        "id": int id,
        "title": String title,
        "description": String description,
      } =>
        HymnCollection(id: id, title: title, description: description),
      _ => throw FormatException("Unrecognised Hymn Collection format"),
    };
  }

  String toJson() => json.encode(toMap());

  factory HymnCollection.fromJson(String source) =>
      HymnCollection.fromMap(json.decode(source));
}
