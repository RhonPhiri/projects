import 'package:nah/data/models/hymn_model.dart';

//For details on extension, check out the dart_fluttering repo => dart_beyond_the_basics => extensions
extension HymnParsing on Hymn {
  List<String> get verses {
    final v =
        (lyrics["verses"] is List)
            ? (lyrics["verses"] as List).map((e) => e.toString()).toList()
            : <String>[];
    return v;
  }

  String get chorus => lyrics["chorus"] as String? ?? '';
}
