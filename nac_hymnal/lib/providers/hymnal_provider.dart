import 'package:flutter/material.dart';
import 'package:nac_hymnal/models/hymnal_model.dart';
import 'package:nac_hymnal/services/hymn_service.dart';

class HymnalProvider with ChangeNotifier {
  //variable to check whether data is still loading or not
  bool _hymnalsLoading = true;
  bool get hymnalsLoading => _hymnalsLoading;

  //variable to hold the list of hymnals loaded from hymnservice
  final List<Hymnal> _hymnals = [];
  List<Hymnal> get hymnals => List.unmodifiable(_hymnals);

  //method to manage the hymnal lists
  void loadHymnals({int? selectedHymnalIndex}) async {
    try {
      // final hymnals = await HymnService.loadHymnals();
      _hymnals.clear();
      // _hymnals.addAll(hymnals);
      //load the stored hymnal
      _hymnalsLoading = false;
    } catch (e) {
      debugPrint('Error loading hymnals: $e');
    } finally {
      notifyListeners();
    }
  }

  //variable to hold the current selected hymnal
  int _selectedHymnalIndex = 0;

  //getter to access the selected hymnal depending on the selected Index
  Hymnal? get selectedHymnal =>
      _hymnals.isNotEmpty ? _hymnals[_selectedHymnalIndex] : null;

  //method to change the current selected Hymnal
  void selectHymnal(int index) {
    _selectedHymnalIndex = index;
    notifyListeners();
  }
}
