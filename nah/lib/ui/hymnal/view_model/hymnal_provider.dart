///this is the hymnal provider class managing the list of hymnals fetched from github
///The app should load the list of hymnals & display a list of hymns from the first hymnal

import 'package:flutter/widgets.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/result.dart';

class HymnalProvider extends ChangeNotifier {
  ///call, using DI the get hymnals method from the hymnal repo
  final HymnalRepository _hymnalRepository;
  final HymnRepository _hymnRepository;

  HymnalProvider(this._hymnRepository, this._hymnalRepository);

  ///variable to hold the error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ///variable to check if the hymnal list is being fetched
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ///Variable to hold the current selected hymnal
  int _selectedHymnal = 0;
  int get selectedHymnal => _selectedHymnal;

  ///variable to hold the list of hymnals
  final List<Hymnal> _hymnalList = [];
  List<Hymnal> get hymnals => List.unmodifiable(_hymnalList);

  ///method to add hymnals to the hymnal list
  Future<void> loadHymnals() async {
    ///start loading process
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final hymnalFetchResult = await _hymnalRepository.getHymnals();

    switch (hymnalFetchResult) {
      case Success<List<Hymnal>> success:
        _hymnalList.clear();
        _hymnalList.addAll(success.data);
        await fetchAndCacheHymnsForAllHymnals(_hymnalList);
        _isLoading = false;
        _errorMessage = '';
        break;
      case Failure<List<Hymnal>> failure:
        _isLoading = false;
        _errorMessage = failure.error.toString();
    }
    notifyListeners();
  }

  ///method to select a different hymnal & get its index
  void selectHymnal(int index) {
    _selectedHymnal = index;
    notifyListeners();
  }

  ///method to cache all hymns associated with each hymnal fetched
  Future<void> fetchAndCacheHymnsForAllHymnals(List<Hymnal> hymnalList) async {
    ///iterate through each hymnal & fetch its hymns
    for (Hymnal hymnal in hymnalList) {
      final hymnFetchResult = await _hymnRepository.getHymns(
        hymnal.language.toLowerCase(),
      );
      if (hymnFetchResult is Success<List<Hymn>>) {
        debugPrint('Hymns for ${hymnal.title} cached successfully');
      } else if (hymnFetchResult is Failure<List<Hymn>>) {
        debugPrint(
          'Error in fetching hymns for ${hymnal.title}: ${hymnFetchResult.error.toString()}',
        );
      }
    }
  }

  ///Get hymnal title
  String getHymnTitle() {
    return _hymnalList.isEmpty ? '' : _hymnalList[_selectedHymnal].title;
  }

  ///Get the current selected hymnal
  Hymnal getSelectedHymnal() {
    return _hymnalList[selectedHymnal];
  }

  @override
  void dispose() async {
    await DatabaseHelper().close();
    super.dispose();
  }
}
