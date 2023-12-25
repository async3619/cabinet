import 'package:cabinet/database/repository/watcher.dart';
import 'package:objectbox/objectbox.dart';

import 'board.dart';
import 'filter.dart';

@Entity()
class Watcher {
  @Id()
  int id = 0;

  String? name;

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

  @Backlink("watcher")
  final filters = ToMany<Filter>();
}
