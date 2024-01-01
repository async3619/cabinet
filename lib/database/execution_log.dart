import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()
class ExecutionLog implements BaseEntity {
  ExecutionLog({
    this.startedAt,
    this.finishedAt,
    this.imageCount,
    this.postCount,
    this.watcherCount,
  });

  @override
  @Id()
  int id = 0;

  int? startedAt;
  int? finishedAt;

  int? imageCount;
  int? postCount;
  int? watcherCount;

  int get executionTime => finishedAt! - startedAt!;
}
