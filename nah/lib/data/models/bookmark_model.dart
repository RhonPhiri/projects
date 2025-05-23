import 'dart:convert';

class Bookmark {
  ///variable to hold the hymn id
  final int id;

  ///variable to hold the hymn title
  final String title;

  ///variable to store the collection title
  final String hymnColTitle;

  ///variable to hold the hymnal language
  final String language;

  Bookmark({
    required this.id,
    required this.title,
    required this.language,
    required this.hymnColTitle,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bookmark &&
        other.id == id &&
        other.title == title &&
        other.language == language &&
        other.hymnColTitle == hymnColTitle;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        language.hashCode ^
        hymnColTitle.hashCode;
  }

  ///Converts the BookmarkedHymn object to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'hymnColTitle': hymnColTitle,
    };
  }

  ///Creates a BookmarkedHymn object from a map
  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        "id": int hymnId,
        "title": String hymnTitle,
        "language": String hymnalLang,
        "hymnColTitle": String hymnColTitle,
      } =>
        Bookmark(
          id: hymnId,
          title: hymnTitle,
          language: hymnalLang,
          hymnColTitle: hymnColTitle,
        ),
      _ => throw FormatException("Unexpected bookmarked hymn format"),
    };
  }

  String toJson() => json.encode(toMap());

  factory Bookmark.fromJson(String source) =>
      Bookmark.fromMap(json.decode(source));
}
