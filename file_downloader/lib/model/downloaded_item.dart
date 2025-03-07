class DownloadedItem {
  final String name;
  const DownloadedItem({required this.name});

  Map<String, String> toJson() {
    return {'name': name};
  }

  factory DownloadedItem.fromJson(Map<String, String> jsonMap) {
    return switch (jsonMap) {
      {'name': String name} => DownloadedItem(name: name),
      _ => throw Exception('Invalid json format'),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadedItem && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
