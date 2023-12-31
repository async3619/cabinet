import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()
class ArchivedPost implements BaseEntity {
  @override
  @Id()
  int id = 0;

  int? no;
  String? boardCode;
  String? rawJson;
}
