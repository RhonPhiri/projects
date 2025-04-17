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

  factory Hymn.fromJson(Map<String, dynamic> jsonMap) {
    return switch (jsonMap) {
      {
        'id': int id,
        'title': String title,
        'otherDetails': String otherDetails,
        'lyrics': Map<String, dynamic> lyrics,
      } =>
        Hymn(id: id, title: title, otherDetails: otherDetails, lyrics: lyrics),
      _ => throw const FormatException('Json format unrecognizeds'),
    };
  }
  /*Sure! The == operator and hashCode overrides are crucial for ensuring that objects are compared
by their content rather than their reference. Here's a detailed explanation:

== Operator Override
By default, Dart compares objects using reference equality, meaning two objects are considered
equal if they are the same instance. However, in many cases, you want to compare objects based
on their properties. Overriding the == operator allows you to define custom equality logic.

In your Hymn class, the == operator is overridden to compare the id, title, nah, and lyrics
properties:

This means two Hymn objects are considered equal if they have the same id, title, nah, and
lyrics.

hashCode Override
The hashCode property is used in hash-based collections like HashSet and HashMap. When you
override the == operator, you must also override hashCode to ensure that equal objects have the
same hash code. This is a requirement for maintaining the integrity of hash-based collections.

In your Hymn class, the hashCode is overridden to generate a hash code based on the id, title,
nah, and lyrics properties:
The ^ operator is a bitwise XOR operation, which combines the hash codes of the properties to
produce a single hash code for the object.

Importance of Overriding == and hashCode
Collection Operations: When you use collections like List, Set, or Map, the == operator and
hashCode are used to determine if an object is already present in the collection. For example,
List.contains, Set.add, and Map.containsKey rely on these overrides.

Removing Objects: As in your case, when you want to remove an object from a collection, the
collection needs to know how to identify the object. Overriding == and hashCode ensures that the
correct object is found and removed.

Equality Comparisons: When you compare two objects for equality, the == operator is used.
Overriding it allows you to define what it means for two objects to be equal based on their
properties.

By overriding these methods, you ensure that your Hymn objects are compared based on their
content, which is essential for correct behavior in collections and other equality checks.
*/
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hymn &&
        other.id == id &&
        other.title == title &&
        other.otherDetails == otherDetails &&
        other.lyrics == lyrics;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        otherDetails.hashCode ^
        lyrics.hashCode;
  }

  @override
  String toString() {
    return 'Hymn: $id\nTitle: $title';
  }
}
