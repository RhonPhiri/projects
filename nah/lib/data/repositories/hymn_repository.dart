import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/services/assert_version_handler.dart';
import 'package:nah/data/services/nah_services_export.dart';

class HymnRepository {
  // The HymnService is injected into the HymnRepository through its constructor,
  // enabling the repository to use the service for fetching hymn data.
  final HymnService hymnService;

  //variable to hold the database
  final DatabaseHelper databaseHelper;

  HymnRepository(this.hymnService, this.databaseHelper);

  /// Fetches a list of hymns based on the specified language.
  ///
  /// [language] - The language for which hymns will be given by the selected hymnal.
  /// Returns a [Result] containing a list of [Hymn] objects if successful.
  /// Throws a [Failure] with an error message if the operation fails.
  ///
  Future<Result<List<Hymn>>> getHymns(String language) async {
    ///Variable to hold the version of hymn data depending on the language, stored in shared preferences
    final hymnVersionKey = "${language}_version";

    ///Variable to hold the file type; hymns or hymnals
    final fileType = "hymns";

    ///Variable to hold the embedded version number
    final embeddedVersion = await AssertVersionHandler.loadEmbeddedVersion(
      fileType,
    );

    ///Variable to hold the stored version number from shared preferences
    final storedVersion = await AssertVersionHandler.getStoredVersion(
      hymnVersionKey,
    );
    try {
      /// Load the embedded files only if the embedded version is greater than the stored version
      if (embeddedVersion > storedVersion) {
        print(
          "Embedded version: $embeddedVersion > Stored version: $storedVersion",
        );

        //Store the embedded version to replace the old stored version
        await AssertVersionHandler.setStoredVersion(
          hymnVersionKey,
          embeddedVersion,
        );

        //Fetch hymns from the embedded files
        final result = await hymnService.fetchHymns(language.toLowerCase());
        if (result is Success<String>) {
          final List<dynamic> hymnData = json.decode(result.data);

          final hymns = [for (final hymn in hymnData) Hymn.fromMap(hymn)];

          //cache the hymns to database
          await databaseHelper.insertHymns(language.toLowerCase(), hymns);
        }
      }

      ///Fetching hymns from database
      final cachedHymns = await databaseHelper.getHymns(language.toLowerCase());

      if (cachedHymns.isNotEmpty) {
        debugPrint('Chached hymns fetched');
        return Success(cachedHymns);
      }
    } catch (e) {
      return Failure(Exception("Failed to load hymns from database: $e"));
    }
    return Failure(
      Exception(
        'Error: Failed to get hymns from hymn service and no cached data available',
      ),
    );
  }

  /// Fetches a hymn based on the specified language & hymnid of a bookmarked hymn.
  /// [language] - The language for which hymns will be given by the selected hymnal.
  /// [hymnId] - The number of the hymn in that selected hymnal
  /// Returns a [Result] containing a list of [Hymn] objects if successful.
  /// Throws a [Failure] with an error message if the operation fails.

  Future<Result<List<Hymn>>> getBookmarkedHymns(
    int hymnId,
    String language,
  ) async {
    final cachedHymns = await databaseHelper.getHymns(language, hymnId: hymnId);
    if (cachedHymns.isNotEmpty) {
      return Success(cachedHymns);
    } else {
      return Failure(
        Exception('Failed to fetch the bookmarked hymn from database'),
      );
    }
  }
}
