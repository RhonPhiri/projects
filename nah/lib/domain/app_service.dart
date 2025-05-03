import 'package:flutter/material.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/services/result.dart';

class AppService {
  final HymnRepository _hymnRepository;
  AppService(this._hymnRepository);

  //method to cache all hymns associated with each hymnal fetched
  Future<void> fetchAndCacheHymnsForAllHymnals(List<Hymnal> hymnalList) async {
    //iterate through each hymnal & fetch its hymns
    for (Hymnal hymnal in hymnalList) {
      final hymnFetchResult = await _hymnRepository.getHymns(
        hymnal.language.toLowerCase(),
      );
      if (hymnFetchResult is Success<List<Hymn>>) {
        debugPrint('Hymns for ${hymnal.title} cached successfully');
      } else if (hymnFetchResult is Failure<List<Hymn>>) {
        debugPrint(
          'Error in fetching hymns for ${hymnal.title}: ${hymnFetchResult.error.toString()}',
        );
      }
    }
  }
}
