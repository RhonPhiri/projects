import 'package:flutter/widgets.dart';
import 'package:nac_hymnal/models/models.dart';

class HymnCollectionProvider with ChangeNotifier {
  //variable to hold various hymn_collections
  final List<HymnCollection> _hymnCollections = [];
  //hymn collection getter
  List<HymnCollection> get hymnCollections =>
      List.unmodifiable(_hymnCollections);

  //method to create a hymnal collection
  void createHymnCollection(HymnCollection hymnCollection) {
    _hymnCollections.add(hymnCollection);
    notifyListeners();
  }

  void toggleCollectionCheckBox({
    required bool newValue,
    required HymnCollection collection,
    required Hymn newHymn,
    required Hymnal? hymnal,
  }) {
    final bookmarkedHymn = BookmarkedHymn(
      id: newHymn.id,
      title: newHymn.title,
      otherDetails: newHymn.otherDetails,
      lyrics: newHymn.lyrics,
      hymnal: hymnal,
    );
    if (newValue &&
        !collection.hymnList.any((bh) => bh.title == newHymn.title)) {
      collection.hymnList.add(bookmarkedHymn);
    } else {
      collection.hymnList.removeWhere(
        (hymnInCollection) => hymnInCollection.title == bookmarkedHymn.title,
      );
    }
    notifyListeners();
  }

  //List of hymnCollections to be removed from the current list
  List<HymnCollection> _hymnCollectionsToDel = [];
  List<HymnCollection> get hymnCollectionsToDel =>
      List.unmodifiable(_hymnCollectionsToDel);

  //method to add a collection or all collections to the hymnCollectionsToDel
  void deOrSelectAll({required bool selectall}) {
    if (selectall) {
      _hymnCollectionsToDel.clear();
      _hymnCollectionsToDel.addAll(_hymnCollections);
    } else {
      _hymnCollectionsToDel.clear();
    }
    notifyListeners();
  }

  void deOrSelectCollection(HymnCollection collection, bool newValue) {
    if (newValue) {
      _hymnCollectionsToDel.add(collection);
    } else {
      _hymnCollectionsToDel.remove(collection);
    }
    notifyListeners();
  }

  //method to delete the selected collections in
  //It's called in the deleteAll icon & singleCollection delete icon
  void deleteCollections({HymnCollection? collection}) {
    //if a collection is provided, then remove that collection, otherwise delete the selected collections
    if (collection != null) {
      _hymnCollections.remove(collection);
    } else {
      _hymnCollections.removeWhere(
        (collection) => _hymnCollectionsToDel.contains(collection),
      );
      _hymnCollectionsToDel.clear();
    }
    notifyListeners();
  }
}
