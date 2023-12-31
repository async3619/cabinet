import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/watcher.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'board.dart';
import 'filter.dart';

@Entity()
class Watcher implements BaseEntity {
  @override
  @Id()
  int id = 0;

  String? name;
  DateTime? lastRun;
  int? crawlingInterval;

  @Transient()
  WatcherStatus? currentStatus;

  int? get status => currentStatus?.index;

  set status(int? value) {
    if (value == null) {
      currentStatus = null;
    } else {
      currentStatus = WatcherStatus.values[value];
    }
  }

  final boards = ToMany<Board>();

  @Backlink('watcher')
  final filters = ToMany<Filter>();

  bool isPostMatch(Post post) {
    final excludingFilters =
        filters.where((element) => element.exclude == true);

    final includingFilters =
        filters.where((element) => element.exclude != true);

    if (excludingFilters.any((element) => element.isPostMatch(post))) {
      return false;
    }

    return includingFilters.any((element) => element.isPostMatch(post));
  }
}
