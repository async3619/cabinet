import 'dart:convert';

import 'package:cabinet/api/base.dart';

import 'package:cabinet/models/board/image_board.dart';

class ImageBoardApi extends BaseApi<ImageBoardBoard> {
  final String baseUrl;

  ImageBoardApi({
    required this.baseUrl
  });

  @override
  Future<List<ImageBoardBoard>> getBoards() async {
    var response = await client.get(Uri.parse('$baseUrl/boards.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load boards');
    }

    final boardMap = jsonDecode(response.body) as Map<String, dynamic>;
    final boards = boardMap.entries.map((entry) {
      return ImageBoardBoard.fromJson(entry.value);
    }).toList();

    return boards;
  }
}