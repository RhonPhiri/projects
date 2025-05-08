import 'package:nah/data/models/hymn_model.dart';
import 'package:nah/data/models/hymnal_model.dart';

const String chiLanguage = 'chichewa';

//variable to hold the json of hymnals as a response by the mocked hymnal service
const mockHymnalJson = '''
      [
        {"id": 1, "title": "Hymnal 1", "language": "English"},
        {"id": 2, "title": "Hymnal 2", "language": "French"}
      ]
    ''';

//Variable to hold a list of hymnals loaded from mocked database
final mockHymnals = [
  Hymnal(id: 1, title: "Hymnal 1", language: "English"),
  Hymnal(id: 2, title: "Hymnal 2", language: "French"),
];

final hymnalList = [
  Hymnal(id: 1, language: chiLanguage, title: "Nyimbo za NAC"),
];

final hymnList = [
  Hymn(
    id: 1,
    title: "Chichewa hymn",
    otherDetails: "Other Details",
    lyrics: {
      "verses": ["Verse 1"],
      "chorus": "",
    },
  ),
];
