import 'package:flutter/widgets.dart';
import 'package:nah/data/models/hymn_collection_model.dart';
import 'package:nah/data/repositories/hymn_collection_repo.dart';
import 'package:nah/data/services/nah_services_export.dart';

class HymnCollectionProvider with ChangeNotifier {
  final HymnCollectionRepo _hymnCollectionRepo;
  HymnCollectionProvider(this._hymnCollectionRepo) {
    loadHymnCols();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorSMS = '';
  String? get errorSMS => _errorSMS;

  ///variable to hold various hymn_collections
  final List<HymnCollection> _hymnCollections = []..reversed;

  ///hymn collection getter
  List<HymnCollection> get hymnCollections =>
      List.unmodifiable(_hymnCollections);

  ///method to create a hymnal collection and add it to the hymnCollections & pendingCollections
  Future<void> createHymnCollection(HymnCollection hymnCollection) async {
    _hymnCollections.add(hymnCollection);
    await _hymnCollectionRepo.cacheHymnCol(hymnCollection);
    notifyListeners();
  }

  ///List of hymnCollections to be removed from the current list
  final List<HymnCollection> _hymnCollectionsToDel = [];

  List<HymnCollection> get hymnCollectionsToDel =>
      List.unmodifiable(_hymnCollectionsToDel);

  ///method to add or deselect all collections to the hymnCollectionsToDel
  void deOrSelectAll({required bool selectall}) {
    if (selectall) {
      _hymnCollectionsToDel.clear();
      _hymnCollectionsToDel.addAll(_hymnCollections);
    } else {
      _hymnCollectionsToDel.clear();
    }
    notifyListeners();
  }

  ///Method to handle selection or deselection of a single collection
  void deOrSelectCollection(HymnCollection collection, bool newValue) {
    if (newValue) {
      _hymnCollectionsToDel.add(collection);
    } else {
      _hymnCollectionsToDel.remove(collection);
    }
    notifyListeners();
  }

  ///method to delete the selected collections in
  ///It's called in the deleteAll icon & singleCollection delete icon
  void deleteCollections({HymnCollection? collection}) async {
    ///if a collection is provided, then remove that collection, otherwise delete the selected collections
    if (collection != null) {
      _hymnCollections.remove(collection);
      await _hymnCollectionRepo.deleteHymnCols([collection]);
    } else {
      _hymnCollections.removeWhere(
        (collection) => _hymnCollectionsToDel.contains(collection),
      );
      await _hymnCollectionRepo.deleteHymnCols(hymnCollectionsToDel);
      _hymnCollectionsToDel.clear();
    }
    notifyListeners();
  }

  ///Method to load hymn collections from database
  Future<void> loadHymnCols() async {
    _isLoading = true;
    _errorSMS = null;
    notifyListeners();
    final result = await _hymnCollectionRepo.fetchHymnCols();
    switch (result) {
      case Success<List<HymnCollection>> success:
        _hymnCollections
          ..clear()
          ..addAll(success.data);
        _isLoading = false;
        _errorSMS = '';
        break;
      case Failure<List<HymnCollection>> failure:
        _isLoading = false;
        _errorSMS = failure.error.toString();
    }
    notifyListeners();
  }
}
