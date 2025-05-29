import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/services/assert_version_handler.dart';
import 'package:nah/data/services/hymnal_service.dart';
import 'package:nah/data/services/result.dart';

//Here the fetched data is converted into the type described by the hymnal_model

typedef StringSuccess = Success<String>;

class HymnalRepository {
  //Access the hymnal service
  final HymnalService _hymnalService;

  //access the nah database through the DatabaseHelper()
  final DatabaseHelper databaseHelper;

  //use dependancy injection to improve testing
  HymnalRepository(this._hymnalService, this.databaseHelper);

  /// Fetches a list of hymnals from the hymnal service.
  ///
  /// This method interacts with the `HymnalService` to retrieve hymnals.
  /// It parses the JSON response into a list of `Hymnal` objects if successful.
  ///
  /// Returns:
  /// - `Success<List<Hymnal>>` if the operation is successful.
  /// - `Failure<String>` if there is an error during the operation.
  Future<Result<List<Hymnal>>> getHymnals() async {
    ///Variable to hold the version of hymn data stored in shared preferences
    final hymnalVersionKey = "hymnals_version";

    ///Variable to hold the file type; hymns or hymnals
    final fileType = "hymnals";

    ///Variable to hold the embedded version number
    final embeddedVersion = await AssertVersionHandler.loadEmbeddedVersion(
      fileType,
    );

    ///Variable to hold the stored version number from shared preferences
    final storedVersion = await AssertVersionHandler.getStoredVersion(
      hymnalVersionKey,
    );
    try {
      //Store the embedded version to replace the old stored version
      if (embeddedVersion > storedVersion) {
        print(
          "Embedded version: $embeddedVersion > Stored version: $storedVersion",
        );

        //Store the embedded version to replace the old stored version
        AssertVersionHandler.setStoredVersion(
          hymnalVersionKey,
          embeddedVersion,
        );

        //fetch hymnals from the hymnal service
        final result = await _hymnalService.fetchHymnals();

        if (result is StringSuccess) {
          //parse the jsonString & return a list of hymnals
          final hymnals = [
            for (final hymnalMap in jsonDecode(result.data))
              Hymnal.fromMap(hymnalMap),
          ];

          //cache the hymnals to database
          await databaseHelper.insertHymnals(hymnals);
        }
      }

      //load cached hymnals from database
      final cachedHymnals = await databaseHelper.getHymnals();

      if (cachedHymnals.isNotEmpty) {
        return Success(cachedHymnals);
      }
    } catch (e) {
      return Failure(Exception("Failed to load hymnals from database"));
    }
    debugPrint('Failed to fetch & load cached hymns');
    return Failure(Exception('Error fetching hymnals from the hymnal service'));
  }
}
