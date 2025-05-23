import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/services/nah_services_export.dart';

class HymnProvider with ChangeNotifier {
  ///variable to hold the hymn repo instance
  final HymnRepository _hymnRepository;
  HymnProvider(this._hymnRepository);

  ///variable to hold the loading state when hymns are being fetched
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ///variable to hold the error sms
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ///varibale to hold the list of hymns
  final List<Hymn> _hymnList = [];
  List<Hymn> get hymnList => List.unmodifiable(_hymnList);

  ///method to fetch hymns from repo
  Future<void> loadHymns(String language) async {
    ///start loading
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final hymnFetchResult = await _hymnRepository.getHymns(
      language.toLowerCase(),
    );
    switch (hymnFetchResult) {
      case Success<List<Hymn>> success:
        _hymnList.clear();
        _hymnList.addAll(success.data);
        _isLoading = false;
        _errorMessage = '';
        break;
      case Failure<List<Hymn>> failure:
        _isLoading = false;
        _errorMessage = failure.error.toString();
    }
    notifyListeners();
  }
}
