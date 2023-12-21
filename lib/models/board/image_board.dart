import 'package:json_annotation/json_annotation.dart';

import 'base.dart';

part 'image_board.g.dart';

@JsonSerializable()
class ImageBoardBoard implements BaseBoard {
  ImageBoardBoard({
    required this.id,
    required this.title,
  });

  @JsonKey(name: 'board')
  @override
  late String id;

  @JsonKey(name: 'title')
  @override
  late String title;

  @override
  String getName() {
    return "/$id/ - $title";
  }

  factory ImageBoardBoard.fromJson(Map<String, dynamic> json) =>
      _$ImageBoardBoardFromJson(json);

  Map<String, dynamic> toJson() => _$ImageBoardBoardToJson(this);
}
