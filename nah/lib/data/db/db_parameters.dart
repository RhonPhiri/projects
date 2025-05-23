const String hymnTableName = "hymns";
const String hymnalTableName = "hymnals";
const String hymnColTableName = "hymnCollections";
const String bookmarkTableName = "bookmarks";

//Database variables
const String idField = "id";
const String titleField = "title";
const String odField = "otherDetails";
const String lyricsField = "lyrics";
const String languageField = "language";
const String descriptionField = "description";
const String hymnColTitleField = "hymnColTitle";

const List<String> hymnColumns = [idField, titleField, odField, lyricsField];
const List<String> hymnalColumns = [idField, titleField, languageField];

//Database variable types
const String idType = "INTEGER";
const String idPrimaryKey = "INTEGER PRIMARY KEY";
const String idTypeAutoIncre = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textPrimaryKey = "TEXT PRIMARY KEY NOT NULL";
const String textType = "TEXT NOT NULL";
const String textTypeNullable = "TEXT";
