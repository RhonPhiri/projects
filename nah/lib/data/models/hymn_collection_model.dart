import 'package:nah/data/models/bookmarked_hymn_model.dart';

class HymnCollection {
  final String title;
  final String description;
  final List<BookmarkedHymn> hymnList;

  HymnCollection({
    required this.title,
    required this.hymnList,
    required this.description,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HymnCollection &&
        other.title == title &&
        other.description == description &&
        other.hymnList == hymnList;
  }

  @override
  int get hashCode {
    return title.hashCode ^ description.hashCode ^ hymnList.hashCode;
  }
}
