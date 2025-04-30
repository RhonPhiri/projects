import 'dart:convert';
import 'package:flutter/foundation.dart';

class Hymn {
  final int id;
  final String title;
  final String otherDetails;
  final Map<String, dynamic> lyrics;

  Hymn({
    required this.id,
    required this.title,
    required this.otherDetails,
    required this.lyrics,
  });

  Hymn copyWith({
    int? id,
    String? title,
    String? otherDetails,
    Map<String, dynamic>? lyrics,
  }) {
    return Hymn(
      id: id ?? this.id,
      title: title ?? this.title,
      otherDetails: otherDetails ?? this.otherDetails,
      lyrics: lyrics ?? this.lyrics,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'otherDetails': otherDetails,
      'lyrics': lyrics,
    };
  }

  factory Hymn.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        "id": int id,
        "title": String title,
        "otherDetails": String otherDetails,
        "lyrics": Map<String, dynamic> lyrics,
      } =>
        Hymn(id: id, title: title, otherDetails: otherDetails, lyrics: lyrics),
      _ => throw Exception('Json format unrecognised'),
    };
  }

  String toJson() => json.encode(toMap());

  factory Hymn.fromJson(String source) => Hymn.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Hymn(id: $id, title: $title, otherDetails: $otherDetails, lyrics: $lyrics)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Hymn &&
        other.id == id &&
        other.title == title &&
        other.otherDetails == otherDetails &&
        mapEquals(other.lyrics, lyrics);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        otherDetails.hashCode ^
        lyrics.hashCode;
  }
}
