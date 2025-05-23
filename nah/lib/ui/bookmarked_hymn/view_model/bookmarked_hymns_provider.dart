///provider to manage the list of hymns that have been added to a certain collection
///This provider is intended to be called when the user is opening the bookmarked hymns
///page.
///It has been created so that when a collection hymnList changes, these changes
///are refrected in this provider via the _bookmarkedHymns field
library;

import 'package:flutter/material.dart';
import 'package:nah/data/models/bookmark_model.dart';
import 'package:nah/data/models/hymn_collection_model.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/repositories/bookmark_repository.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/services/nah_services_export.dart';

class BookmarkedHymnsProvider with ChangeNotifier {
  final HymnRepository _hymnRepository;
  final BookmarkRepository _bookmarkRepository;
  BookmarkedHymnsProvider(this._hymnRepository, this._bookmarkRepository) {
    loadBookmarks();
  }

  ///Variable to show if the bookmarked hymns in this collection are being fetched from database
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ///variable to hold the error sms
  String? _errorSms;
  String? get errorSms => _errorSms;

  ///variable to hold the current bh being viewed
  List<Hymn> _bookmarkedHymns = [];
  List<Hymn> get bookmarkedHymns => List.unmodifiable(_bookmarkedHymns);

  ///field to store the list of bookmarkes
  List<Bookmark> _bookmarks = [];
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);

  ///field to store the current selected collection
  HymnCollection _hymnCollection = HymnCollection(title: '', description: '');
  HymnCollection get hymnCollection => _hymnCollection;

  ///method to asign the collection when clicked
  ///Also called to add the list of bookmarkedhymns
  void updateCollection({HymnCollection? collection}) {
    if (collection != null) {
      _hymnCollection = collection;
    }
  }

  ///Method to toggle the checkBox of a particular hymnCollection
  void toggleCollectionCheckBox({
    required int hymnId,
    required String hymnTitle,
    required String hymnalTitle,
    required String hymnalLang,
    required String hymnColTitle,
  }) async {
    final newBookamrk = Bookmark(
      id: hymnId,
      title: hymnTitle,
      language: hymnalLang,
      hymnColTitle: hymnColTitle,
    );

    if (!_bookmarks.any((bookmark) => bookmark == newBookamrk)) {
      _bookmarks.add(newBookamrk);
      await _bookmarkRepository.chacheBookmark(newBookamrk);
      print("${newBookamrk.title} cached successfully: provider");
      // print('bookmark hymn added');
    } else {
      _bookmarks.remove(newBookamrk);
      await _bookmarkRepository.deleteBookmarks([newBookamrk]);
      print(
        "${newBookamrk.title} deleted from database successfully...: provider",
      );
      // print('bookmark hymn removed');
    }
    notifyListeners();
  }

  ///Method to fetch bookmarks
  Future<void> loadBookmarks() async {
    if (_bookmarks.isEmpty) {
      _isLoading = true;
      notifyListeners();
      final result = await _bookmarkRepository.fetchBookmarks();
      switch (result) {
        case Success<List<Bookmark>> success:
          _bookmarks
            ..clear()
            ..addAll(success.data);
          print("Bookmarks loaded successfully");
          _isLoading = false;
          break;
        case Failure<List<Bookmark>> failure:
          print(failure.error.toString());
      }
      notifyListeners();
    }
  }

  ///Method to delete bookmarks from a collection
  Future<void> deleteBookmarks(HymnCollection collection) async {
    final bookmarksToDel =
        _bookmarks
            .where((bookmark) => bookmark.hymnColTitle == collection.title)
            .toList();
    await _bookmarkRepository.deleteBookmarks(bookmarksToDel);
    print("Bookmarks deleted: provider");
  }

  //Method to load hymns from the database that are associated with a particular bookmark
  Future<void> loadBookmarkedHymnsForCollection(
    HymnCollection collection,
  ) async {
    _isLoading = true;
    notifyListeners();
    debugPrint("Bh loading...");
    //filter bookmarks for this collection
    final collectionBookmarks =
        _bookmarks.where((b) => b.hymnColTitle == collection.title).toList();

    //fetch hymns from DB for each bookmark
    final hymns = <Hymn>[];

    for (final bookmark in collectionBookmarks) {
      final result = await _hymnRepository.getBookmarkedHymns(
        bookmark.id,
        bookmark.language,
      );
      if (result is Success<List<Hymn>>) {
        hymns.addAll(result.data);
        debugPrint("${result.data} added");
      } else if (result is Failure<List<Hymn>>) {
        debugPrint("${result.error}");
      }
    }
    _bookmarkedHymns = hymns;
    _isLoading = false;
    notifyListeners();
    debugPrint("Bh data available...");
  }
}
