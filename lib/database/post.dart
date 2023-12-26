import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'board.dart';
import 'image.dart';

@Entity()
class Post implements BaseEntity {
  @override
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

  @Backlink('posts')
  final images = ToMany<Image>();

  String? get thumbnailUrl {
    if (images.isEmpty) {
      return null;
    }

    return images[0].thumbnailUrl;
  }

  @override
  String toString() {
    return "Post(id: $id, no: $no, board: ${board.target?.code ?? "(not set)"} title: $title, content: $content, author: $author, createdAt: $createdAt)";
  }
}
