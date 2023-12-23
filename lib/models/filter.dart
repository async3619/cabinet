enum SearchLocation {
  Subject,
  Content,
  SubjectContent,
}

class Filter {
  final String keyword;
  final SearchLocation location;
  final bool caseSensitive;

  Filter({
    required this.keyword,
    required this.location,
    required this.caseSensitive,
  });
}
