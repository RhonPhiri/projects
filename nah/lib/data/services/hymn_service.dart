//Class to fetch hymn data

import 'package:flutter/widgets.dart';

import 'nah_services_export.dart';

class HymnService extends BaseService {
  //fetch hymn data using the fetch data method
  Future<Result<String>> fetchHymns(String language) async {
    final hymnFilePath = 'assets/hymns/$language.json';
    debugPrint("hymns fetched");
    return fetchData(hymnFilePath);
  }
}
