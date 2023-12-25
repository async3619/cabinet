import 'package:objectbox/objectbox.dart';

import 'post.dart';

@Entity()
class Image {
  Image(
    this.filename,
    this.extension,
    this.width,
    this.height,
    this.thumbnailWidth,
    this.thumbnailHeight,
    this.time,
    this.size,
    this.md5,
  );

  @Id()
  int id = 0;

  String? filename;
  String? extension;
  int? width;
  int? height;
  int? thumbnailWidth;
  int? thumbnailHeight;
  int? time;
  int? size;
  String? md5;

  final posts = ToMany<Post>();
}
