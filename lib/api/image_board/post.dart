import 'package:cabinet/api/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class ImageBoardPost implements BasePost {
  static DateTime? _fromJson(int? int) {
    if (int == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(int * 1000);
  }

  static int? _toJson(DateTime? time) {
    if (time == null) return null;
    return time.millisecondsSinceEpoch ~/ 1000;
  }

  ImageBoardPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  @JsonKey(name: 'no')
  @override
  late int id;

  @JsonKey(name: 'sub')
  @override
  late String? title;

  @JsonKey(name: 'com')
  @override
  late String? content;

  @JsonKey(name: 'name')
  @override
  late String? author;

  @JsonKey(name: 'time', fromJson: _fromJson, toJson: _toJson)
  @override
  late DateTime? createdAt;

  @JsonKey(name: 'filename')
  late String? filename;

  @JsonKey(name: 'ext')
  late String? extension;

  @JsonKey(name: 'w')
  late int? width;

  @JsonKey(name: 'h')
  late int? height;

  @JsonKey(name: 'tn_w')
  late int? thumbnailWidth;

  @JsonKey(name: 'tn_h')
  late int? thumbnailHeight;

  @JsonKey(name: 'tim')
  late int? imageTime;

  @JsonKey(name: 'md5')
  late String? imageMd5;

  @JsonKey(name: 'fsize')
  late int? imageSize;

  factory ImageBoardPost.fromJson(Map<String, dynamic> json) =>
      _$ImageBoardPostFromJson(json);

  Map<String, dynamic> toJson() => _$ImageBoardPostToJson(this);
}
