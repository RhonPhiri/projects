import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/models/hymn_collection_model.dart';
import 'package:nah/data/services/result.dart';

class HymnCollectionRepo {
  ///Using depency injection
  final DatabaseHelper _databaseHelper;

  HymnCollectionRepo(this._databaseHelper);

  ///Method to cache hymnCollections into the database
  Future<void> cacheHymnCol(HymnCollection hymnCol) async {
    await _databaseHelper.insertHymnCollection(hymnCol);
  }

  ///Method to delete a hymn collection
  Future<void> deleteHymnCols(List<HymnCollection> hymnColsToDel) async {
    await _databaseHelper.deleteHymnCols(hymnColsToDel);
  }

  ///Method to retrieve hymnCols from the database
  Future<Result<List<HymnCollection>>> fetchHymnCols() async {
    try {
      final cachedHymnCols = await _databaseHelper.getHymnCols();
      if (cachedHymnCols.isNotEmpty) {
        return Success(cachedHymnCols);
      } else {
        return Failure(
          Exception("No cached hymn collections were found in the database"),
        );
      }
    } catch (e) {
      return Failure(
        Exception("Failed to load cached hymn collections from database"),
      );
    }
  }
}
