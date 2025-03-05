class Avatar {
  final String name;
  final String url;

  Avatar({
    required this.name,
    required this.url,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Avatar && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
