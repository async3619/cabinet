import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()
class Blacklist implements BaseEntity {
  @override
  @Id()
  int id = 0;

  int? boardId;
  int? postId;
}
