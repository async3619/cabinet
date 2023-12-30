import 'package:cabinet/database/post.dart';
import 'package:objectbox/objectbox.dart';

import 'watcher.dart';

enum SearchLocation {
  subject,
  content,
  subjectContent,
}

@Entity()
class Filter {
  @Id()
  int id = 0;

  String? keyword;
  bool? caseSensitive;

  final watcher = ToOne<Watcher>();

  @Transient()
  SearchLocation? location;

  int? get dbLocation {
    _ensureSearchLocationValue();
    return location!.index;
  }

  set dbLocation(int? value) {
    _ensureSearchLocationValue();
    if (value == null) {
      location = null;
    } else {
      location = SearchLocation.values[value];
    }
  }

  void _ensureSearchLocationValue() {
    assert(SearchLocation.subject.index == 0);
    assert(SearchLocation.content.index == 1);
    assert(SearchLocation.subjectContent.index == 2);
  }

  bool isPostMatch(Post post) {
    final keyword = this.keyword;
    if (keyword == null) {
      return false;
    }

    final caseSensitive = this.caseSensitive ?? false;
    final location = this.location ?? SearchLocation.subjectContent;

    final subject = post.title;
    final content = post.content;

    if (subject == null && content == null) {
      return false;
    }

    var subjectMatch = false;
    var contentMatch = false;

    if (subject != null) {
      subjectMatch = caseSensitive
          ? subject.contains(keyword)
          : subject.toLowerCase().contains(keyword.toLowerCase());
    }

    if (content != null) {
      contentMatch = caseSensitive
          ? content.contains(keyword)
          : content.toLowerCase().contains(keyword.toLowerCase());
    }

    switch (location) {
      case SearchLocation.subject:
        return subjectMatch;
      case SearchLocation.content:
        return contentMatch;
      case SearchLocation.subjectContent:
        return subjectMatch || contentMatch;
    }
  }
}
