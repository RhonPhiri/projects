//This is where the hymnal raw data is fetched whether API or Database and handle caching
//when I tested without an internet connection, an exption was thrown by http because it wasn't
//wrapped & caught in the failure class
//Solution was to add a try-catch block and retain a failure
import 'dart:io';

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
    try {
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
    } on SocketException catch (e) {
      return Failure(
        Exception('No internet connection. Please try again later.'),
      );
    } on http.ClientException catch (e) {
      return Failure(Exception('Failed to connect to the server.'));
    } catch (e) {
      return Failure(Exception('An unexpected error occurred. Details: $e'));
    }
  }

  //A retry mechanism to retry fetching hymnals
  Future<Result<String>> fetchHymnalsWithRetry({int retries = 3}) async {
    for (var i = 0; i < retries; i++) {
      final result = await fetchHymnals();
      if (result is Success) {
        return result;
      }
      await Future.delayed(Duration(seconds: 2));
    }
    final error = await fetchHymnals();
    return error;
  }
}
