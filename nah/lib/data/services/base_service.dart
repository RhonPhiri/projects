import 'dart:io';
import 'package:http/http.dart' as http;
import 'nah_services_export.dart';

//This is an abstract class containing the common properties & variables used by the hymn & hymnal service classes
abstract class BaseService {
  //using dependency injection to allow for testing
  final http.Client client;
  //initializing client upon calling the constructor, making it optional or else use the http
  BaseService({http.Client? client}) : client = client ?? http.Client();

  //method to fetch data using the url
  /// Fetches hymnals from the specified URL.
  /// Returns a [Result] containing the hymnals as a JSON string if successful,
  /// or an error if the fetch operation fails.
  Future<Result<String>> fetchData(String url) async {
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Success(response.body);
      } else {
        return Failure(
          Exception(
            'Failed to fetch Data. Status Code: ${response.statusCode}. Response: ${response.statusCode}',
          ),
        );
      }
    } on SocketException catch (e) {
      return Failure(
        Exception('No internet connection. Please try again later'),
      );
    } on http.ClientException catch (e) {
      return Failure(Exception('Failed to connect to the server'));
    } catch (e) {
      return Failure(Exception('An unexpected error occured. Details: $e'));
    }
  }

  //A retry mechanism to retry fetching data
  Future<Result<String>> fetchDataWithRetries({
    int retries = 3,
    required String url,
  }) async {
    for (var i = 0; i < retries; i++) {
      final result = await fetchData(url);
      if (result is Success) {
        return result;
      }
      await Future.delayed(Duration(seconds: 2));
    }
    final error = await fetchData(url);
    return error;
  }
}
