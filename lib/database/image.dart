import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'post.dart';

@Entity()
class Image implements BaseEntity {
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
    this.url,
    this.thumbnailUrl,
  );

  @override
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
  String? url;
  String? thumbnailUrl;
  String? path;
  String? thumbnailPath;

  final posts = ToMany<Post>();

  @Transient()
  bool get isVideo {
    return extension == '.webm' || extension == '.mp4';
  }

  @Transient()
  bool get isImage {
    return !isVideo;
  }
}
