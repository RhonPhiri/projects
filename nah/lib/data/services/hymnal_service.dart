//This is where the hymnal raw data is fetched

import 'nah_services_export.dart';

class HymnalService extends BaseService {
  HymnalService({super.client});

  //property to hold the hymnal url
  final _url = 'https://rhonphiri.github.io/nac-hymnal-files/hymnals.json';

  //method to fetch hymnals from the repo
  Future<Result<String>> fetchHymnalsWithRetry() async {
    return fetchDataWithRetries(url: _url);
  }
}
