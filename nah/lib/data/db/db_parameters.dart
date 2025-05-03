const String hymnTableName = "hymns";
const String hymnalTableName = "hymnals";

const String idField = "id";
const String titleField = "title";
const String odField = "otherDetails";
const String lyricsField = "lyrics";
const String languageField = "language";

const List<String> hymnColumns = [idField, titleField, odField, lyricsField];
const List<String> hymnalColumns = [idField, titleField, languageField];

const String idType = "INTEGER PRIMARY KEY";
const String idTypeAutoIncre = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textType = "TEXT NOT NULL";
const String textTypeNullable = "TEXT";
