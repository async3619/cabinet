import 'package:json_annotation/json_annotation.dart';

import '../board.dart';

part 'board.g.dart';

@JsonSerializable()
class ImageBoardBoard implements BaseBoard {
  ImageBoardBoard({
    required this.id,
    required this.title,
    required this.description,
  });

  @JsonKey(name: 'board')
  @override
  late String id;

  @JsonKey(name: 'title')
  @override
  late String title;

  @JsonKey(name: 'meta_description')
  late String description;

  @override
  String getName() {
    return "/$id/ - $title";
  }

  factory ImageBoardBoard.fromJson(Map<String, dynamic> json) =>
      _$ImageBoardBoardFromJson(json);

  Map<String, dynamic> toJson() => _$ImageBoardBoardToJson(this);
}
