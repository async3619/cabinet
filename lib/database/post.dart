import 'package:objectbox/objectbox.dart';

import 'board.dart';

@Entity()
class Post {
  @Id()
  int id = 0;

  int? no;
  String? title;
  String? content;
  String? author;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  final board = ToOne<Board>();
  final parent = ToOne<Post>();

  @Backlink('parent')
  final children = ToMany<Post>();

  @override
  String toString() {
    return "Post(id: $id, no: $no, board: ${board.target?.code ?? "(not set)"} title: $title, content: $content, author: $author, createdAt: $createdAt)";
  }
}
