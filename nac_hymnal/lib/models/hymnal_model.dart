class Hymnal {
  final int id;
  final String language;
  final String title;

  Hymnal({required this.id, required this.language, required this.title});

  //the copyWith method, to retain all the properties of the object except for isSelected property if provided
  Hymnal copyWith({bool? isSelected}) {
    return Hymnal(id: id, language: language, title: title);
  }

  //from json method to parse through the hymnal json file
  factory Hymnal.fromJson(Map<String, dynamic> jsonMap) {
    return switch (jsonMap) {
      {"id": int id, "language": String language, "title": String title} =>
        Hymnal(id: id, language: language, title: title),
      _ =>
        throw const FormatException(
          'The json format from the configuration is unrecognised',
        ),
    };
  }
}
