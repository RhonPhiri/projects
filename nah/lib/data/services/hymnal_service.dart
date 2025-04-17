//This is where the hymnal raw data is fetched whether API or Database and handle caching

import 'package:nah/data/services/result.dart';
import 'package:http/http.dart' as http;

class HymnalService {
  //variable to hold the github hymnal.json url
  final _hymnalUrl =
      'https://rhonphiri.github.io/nac-hymnal-files/hymnals.json';

  //method to fetch hymnals using the url
  /// Fetches hymnals from the specified URL.
  ///
  /// Returns a [Result] containing the hymnals as a JSON string if successful,
  /// or an error if the fetch operation fails.
  Future<Result<String>> fetchHymnals() async {
    final response = await http.get(Uri.parse(_hymnalUrl));
    if (response.statusCode == 200) {
      return Success(response.body);
    } else {
      return Failure(
        Exception(
          'Failed to fetch hymnals. Status code: ${response.statusCode}, Response: ${response.body}',
        ),
      );
    }
  }
}
