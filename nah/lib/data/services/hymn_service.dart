//Class to fetch hymn data

import 'nah_services_export.dart';

class HymnService extends BaseService {
  //get the client from the abstract class.
  HymnService({super.client});

  //provide the url to fetch hymn data
  final _url = 'https://rhonphiri.github.io/nac-hymnal-files/';

  //fetch hymn data using the fetch data method
  Future<Result<String>> fetchHymns(String language) async {
    final hymnUrl = '$_url$language.json';
    return fetchData(hymnUrl);
  }
}
