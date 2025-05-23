import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/models/bookmark_model.dart';
import 'package:nah/data/services/nah_services_export.dart';

class BookmarkRepository {
  final DatabaseHelper _databaseHelper;

  BookmarkRepository(this._databaseHelper);

  ///method to cache bookmarks to database
  Future<void> chacheBookmark(Bookmark bookmark) async {
    await _databaseHelper.insertBookmark(bookmark);
    print("cachedBookmarks cached successfully: from repo");
  }

  ///Method to get bookmarks from database
  Future<Result<List<Bookmark>>> fetchBookmarks() async {
    try {
      final cachedBookmarks = await _databaseHelper.getBookmarks();
      if (cachedBookmarks.isNotEmpty) {
        print("Bookmarks fetched successfully: from repo");

        return Success(cachedBookmarks);
      }
      print("Bookmarks not fetched successfully: from repo");

      return Failure(Exception('Failed to retrive bookmarks from database'));
    } catch (e) {
      return Failure(
        Exception(
          "Failed to retrieve bookmarks from database: ${e.toString()}",
        ),
      );
    }
  }

  ///method to delete bookmarks from database
  Future<void> deleteBookmarks(List<Bookmark> bookmarksToDel) async {
    await _databaseHelper.deleteBookmarks(bookmarksToDel);
    print("Bookmarks deleted successfully: from repo");
  }
}
