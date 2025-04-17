import 'package:nac_hymnal/models/models.dart';

class BookmarkedHymn extends Hymn {
  //the hymnal can be null since it is loaded async after the hymns have been loaded
  final Hymnal? hymnal;

  BookmarkedHymn({
    required super.id,
    required super.title,
    required super.otherDetails,
    required super.lyrics,
    required this.hymnal,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookmarkedHymn &&
        other.id == id &&
        other.title == title &&
        other.otherDetails == otherDetails &&
        other.lyrics == lyrics &&
        other.hymnal == hymnal;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        otherDetails.hashCode ^
        lyrics.hashCode ^
        hymnal.hashCode;
  }
}
