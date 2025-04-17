//provider to manage the list of hymns that have been added to a certain collection
//This provider is intended to be called when the user is opening the bookmarked hymns
//page.
//It has been created so that when a collection hymnList changes, these changes
//are refrected in this provider via the _bookmarkedHymns field

import 'package:flutter/material.dart';
import 'package:nac_hymnal/models/bookmarked_hymn_model.dart';
import 'package:nac_hymnal/models/hymn_collection_model.dart';

class BookmarkedHymnsProvider with ChangeNotifier {
  //field to store the list of bookmarkedHymns
  final List<BookmarkedHymn> _bookmarkedHymns = [];
  List<BookmarkedHymn> get bookmarkedHymns =>
      List.unmodifiable(_bookmarkedHymns);

  //field to store the current selected collection
  HymnCollection _hymnCollection = HymnCollection(
    title: '',
    hymnList: [],
    description: '',
  );
  HymnCollection get hymnCollection => _hymnCollection;

  //method to asign the collection when clicked
  //Also called to add the list of bookmarkedhymns
  void updateCollection({HymnCollection? collection}) {
    if (collection != null) {
      _hymnCollection = collection;
    }
    _bookmarkedHymns
      ..clear()
      ..addAll(_hymnCollection.hymnList);
    notifyListeners();
  }
}
