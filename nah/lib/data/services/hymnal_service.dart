//This is where the hymnal raw data is fetched

import 'nah_services_export.dart';

class HymnalService extends BaseService {
  //method to fetch hymnals from the repo
  Future<Result<String>> fetchHymnals() async {
    final hymnalFilePath = 'assets/hymnals/hymnals.json';
    return fetchData(hymnalFilePath);
  }
}
