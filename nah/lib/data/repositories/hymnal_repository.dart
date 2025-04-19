import 'dart:convert';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/services/hymnal_service.dart';
import 'package:nah/data/services/result.dart';

//Here the fetched data is converted into the type described by the hymnal_model

typedef StringSuccess = Success<String>;

class HymnalRepository {
  //Access the hymnal service
  final HymnalService _hymnalService;
  //use dependancy injection to improve testing
  HymnalRepository(this._hymnalService);

  /// Fetches a list of hymnals from the hymnal service.
  ///
  /// This method interacts with the `HymnalService` to retrieve hymnals.
  /// It parses the JSON response into a list of `Hymnal` objects if successful.
  ///
  /// Returns:
  /// - `Success<List<Hymnal>>` if the operation is successful.
  /// - `Failure<String>` if there is an error during the operation.
  Future<Result<List<Hymnal>>> getHymnals() async {
    final result = await _hymnalService.fetchHymnalsWithRetry();

    if (result is StringSuccess) {
      //parse the jsonString & return a list of hymnals
      final hymnals = [
        for (final hymnalMap in jsonDecode(result.data))
          Hymnal.fromMap(hymnalMap),
      ];
      return Success(hymnals);
    } else if (result is Failure<String>) {
      return Failure(result.error);
    }
    return Failure(Exception('Error fetching hymnals from the hymnal service'));
  }
}
