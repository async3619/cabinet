import 'package:objectbox/objectbox.dart';

import 'post.dart';
import 'watcher.dart';

@Entity()
class Board {
  @Id()
  int id = 0;

  String? code;
  String? title;
  String? description;

  final watchers = ToMany<Watcher>();

  @Backlink('board')
  final posts = ToMany<Post>();

  @Transient()
  String get name => "/$code/ - $title";
}
