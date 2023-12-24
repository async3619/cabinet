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
}
