import 'package:objectbox/objectbox.dart';

import 'board.dart';
import 'filter.dart';

@Entity()
class Watcher {
  @Id()
  int id = 0;

  String? name;

  final boards = ToMany<Board>();

  @Backlink("watcher")
  final filters = ToMany<Filter>();
}
