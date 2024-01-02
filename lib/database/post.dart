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
  bool? isArchived;
  bool? isRead;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  final board = ToOne<Board>();
  final parent = ToOne<Post>();
  final replyParent = ToMany<Post>();

  @Backlink('parent')
  final children = ToMany<Post>();

  @Backlink('replyParent')
  final replies = ToMany<Post>();

  @Backlink('posts')
  final images = ToMany<Image>();

  @Transient()
  int get imageCount {
    return images.length +
        children.fold(0, (previousValue, element) {
          return previousValue + element.imageCount;
        });
  }

  @Transient()
  int get childCount => children.length;

  @Transient()
  int get replyCount => replies.length;

  @Transient()
  bool get allRead => children.every((element) => element.isRead == true);

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
