import 'package:objectbox/objectbox.dart';

import 'watcher.dart';

enum SearchLocation {
  Subject,
  Content,
  SubjectContent,
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
    assert(SearchLocation.Subject.index == 0);
    assert(SearchLocation.Content.index == 1);
    assert(SearchLocation.SubjectContent.index == 2);
  }
}
