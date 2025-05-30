///DatabaseHelper class to manage the database for the hymns & hymnals
///Will use the singleton pattern to allow only a single instanciation of the databsehelper class
///and use the instance grobally
library;

import 'dart:convert';
import 'package:nah/data/db/db_parameters.dart';
import 'package:nah/data/models/bookmark_model.dart';
import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/models/hymnal_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/hymn_collection_model.dart';

class DatabaseHelper {
  ///variable to hold the database name
  final String databaseName = 'nah.db';

  ///Creating a private constructor to prevent external instantiation of the class
  DatabaseHelper._internal();

  ///creating a private instance to hold instance of this class & supply it globally
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  ///factory constructors return an existing instance of a class hence instead of making instance public, instance is private, not to be accessed outside too
  ///But when the user calls DatabaseHelper(), they are calling a factory constructor because it can be unnamed
  factory DatabaseHelper() => _instance;

  ///property to cache the database so that it doesn't reopen when called, static makes it lazy
  static Database? _database;

  ///lazy opening of the database
  ///check if the database is already open, assign a database if not, & return it
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase(databaseName);
    return _database!;
  }

  ///Method to create the tables for the hymnals & hymns respectively
  Future<void> _createDB(Database db, int version) async {
    ///create hymns table
    ///each hymn row will have a language field for querying, A one (hymnal) to many (hymns) relationship
    ///each row will be uniquely identified by its id & language
    await db.execute('''
      CREATE TABLE $hymnTableName (
        $idField $idType,
        $languageField $textType,
        $titleField $textType,
        $odField $textTypeNullable,
        $lyricsField $textType,
        PRIMARY KEY ($idField, $languageField) -- Composite primary key
      )
    ''');

    ///create hymnals table
    await db.execute('''
      CREATE TABLE $hymnalTableName (
        $idField $idPrimaryKey,
        $titleField $textType,
        $languageField $textType
      )
    ''');

    ///Create hymnCollection table
    await db.execute('''
      CREATE TABLE $hymnColTableName (
        $idField $idTypeAutoIncre,
        $titleField $textType UNIQUE,
        $descriptionField $textTypeNullable
      )
    ''');

    ///create bookmark table
    await db.execute('''
      CREATE TABLE $bookmarkTableName (
        $idField $idType,
        $titleField $textType,
        $languageField $textType,
        $hymnColTitleField $textType
      )
     ''');

    ///The method below will create a copy of the languageField. When the gethymns method searchs the where arguments and locates
    ///the row with the language & id, it will quickly refer to that row
    await db.execute(
      'CREATE INDEX idx_hymns_language_id ON $hymnTableName ($languageField, $idField)',
    );
  }

  ///Method to open the database or create one
  Future<Database> _initDatabase(String fileName) async {
    ///first access the device storage files using sqflite
    final dbPath = await getDatabasesPath();

    ///the open database method by sqflite requires the path of the database
    ///Path package provides the correct format of representing the native path
    return openDatabase(
      join(dbPath, fileName),
      version: 1,

      ///oncreate allows creation of the database if opendatabase found a non existing database
      onCreate: _createDB,
    );
  }

  ///Insert hymnals into the database
  Future<void> insertHymnals(List<Hymnal> hymnals) async {
    final db = await database;
    for (Hymnal hymnal in hymnals) {
      await db.insert(
        hymnalTableName,
        hymnal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  ///retrive hymnals from the database
  Future<List<Hymnal>> getHymnals() async {
    final db = await database;
    final hymnalMaps = await db.query(hymnalTableName);
    return hymnalMaps.map((map) => Hymnal.fromMap(map)).toList();
  }

  ///insert hymns into the database
  Future<void> insertHymns(String language, List<Hymn> hymns) async {
    final db = await database;
    final batch = db.batch();

    for (Hymn hymn in hymns) {
      batch.insert(hymnTableName, {
        'language': language.toLowerCase(),
        ...hymn.toMap(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    ///The method bellow is to add all the hymns in a single transaction & not a single hymns @ a time
    await batch.commit(noResult: true);
  }

  ///method to retrieve hymns from database
  Future<List<Hymn>> getHymns(String language, {int? hymnId}) async {
    final db = await database;
    List<Map<String, Object?>> hymnMaps = [];
    if (hymnId != null) {
      hymnMaps = await db.query(
        hymnTableName,
        where: '$idField= ? AND $languageField = ?',
        whereArgs: [hymnId, language.toLowerCase()],
      );
    } else {
      hymnMaps = await db.query(
        hymnTableName,
        where: '$languageField = ?',
        whereArgs: [language.toLowerCase()],
      );
    }

    return hymnMaps.map((map) {
      return Hymn(
        id: map['id'] as int,
        title: map['title'] as String,
        otherDetails: map['otherDetails'] as String,
        lyrics: json.decode(map['lyrics'] as String),

        /// Convert JSON string back to Map
      );
    }).toList();
  }

  ///method to insert hymncollections into the database
  Future<void> insertHymnCollection(HymnCollection hymnCol) async {
    final db = await database;
    await db.insert(
      hymnColTableName,
      hymnCol.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///method to retrieve the hymn collections from database
  Future<List<HymnCollection>> getHymnCols() async {
    final db = await database;
    final hymnColMaps = await db.query(hymnColTableName);

    return hymnColMaps
        .map((hymnColMap) => HymnCollection.fromMap(hymnColMap))
        .toList();
  }

  ///Method to delete hymnCollections
  Future<void> deleteHymnCols(List<HymnCollection> hymnColsToDel) async {
    final db = await database;

    final batch = db.batch();
    for (HymnCollection hymnCol in hymnColsToDel) {
      if (hymnCol.id != null) {
        batch.delete(
          hymnColTableName,
          where: "$idField = ?",
          whereArgs: [hymnCol.id],
        );
      }
    }
    await batch.commit(noResult: true);
  }

  //Method to cache bookamrks
  Future<void> insertBookmark(Bookmark bookmark) async {
    final db = await database;
    await db.insert(
      bookmarkTableName,
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Method to retrieve bookamrks
  Future<List<Bookmark>> getBookmarks() async {
    final db = await database;
    final bookmarkMaps = await db.query(bookmarkTableName);
    return bookmarkMaps
        .map((bookmarkMap) => Bookmark.fromMap(bookmarkMap))
        .toList();
  }

  //Method to delete bookmarks
  Future<void> deleteBookmarks(List<Bookmark> bookmarksToDel) async {
    final db = await database;
    final batch = db.batch();
    for (Bookmark bookmark in bookmarksToDel) {
      batch.delete(
        bookmarkTableName,
        where: '$idField = ? AND $hymnColTitleField = ?',
        whereArgs: [bookmark.id, bookmark.hymnColTitle.toLowerCase()],
      );
    }
    batch.commit(noResult: true);
  }

  ///Method to release resources when database is not needed
  Future<void> close() async {
    final db = await database;
    return db.close();
  }
}
