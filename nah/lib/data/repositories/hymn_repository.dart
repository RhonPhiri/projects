import 'dart:convert';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/services/nah_services_export.dart';

class HymnRepository {
  // The HymnService is injected into the HymnRepository through its constructor,
  // enabling the repository to use the service for fetching hymn data.
  final HymnService hymnService;

  HymnRepository(this.hymnService);

  /// Fetches a list of hymns based on the specified language.
  ///
  /// [language] - The language for which hymns will be given by the selected hymnal.
  /// Returns a [Result] containing a list of [Hymn] objects if successful.
  /// Throws a [Failure] with an error message if the operation fails.
  ///
  Future<Result<List<Hymn>>> getHymns(String language) async {
    final result = await hymnService.fetchHymns(language);
    if (result is Success<String>) {
      final hymnData = json.decode(result.data);

      final hymns = [for (final hymn in hymnData) Hymn.fromMap(hymn)];
      return Success(hymns);
    } else if (result is Failure<String>) {
      return Failure(result.error);
    }
    return Failure(Exception('Error: Failed to get hymns from hymn service'));
  }
}
