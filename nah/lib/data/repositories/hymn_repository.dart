import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/models/hymn_model.dart';
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
    try {
      final result = await hymnService.fetchHymns(language.toLowerCase());
      if (result is Success<String>) {
        final List<dynamic> hymnData = json.decode(result.data);

        final hymns = [for (final hymn in hymnData) Hymn.fromMap(hymn)];

        //cache the hymns to database
        await databaseHelper.insertHymns(language.toLowerCase(), hymns);

        return Success(hymns);
      }
      //if result is an error
      throw Exception((result as Failure).error);
      //catch the error & fall back on the cached hymns
    } catch (e) {
      //fallback to cached hymns
      final cachedHymns = await databaseHelper.getHymnsByLanguage(
        language.toLowerCase(),
      );
      if (cachedHymns.isNotEmpty) {
        return Success(cachedHymns);
      }
      debugPrint('Chached hymns fetched');
    }
    debugPrint('Failed to fetch & load cached hymns');
    return Failure(
      Exception(
        'Error: Failed to get hymns from hymn service and no cached data available',
      ),
    );
  }
}
