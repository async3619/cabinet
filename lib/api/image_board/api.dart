import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';

import 'package:cabinet/api/base.dart';

import 'board.dart';

class ImageBoardApi extends BaseApi<ImageBoardBoard> {
  final String baseUrl;

  ImageBoardApi({required this.baseUrl});

  @override
  Future<List<ImageBoardBoard>> getBoards() async {
    var response = await client.get(Uri.parse('$baseUrl/boards.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load boards');
    }

    final rawResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final rawBoards = rawResponse['boards'] as List<dynamic>;
    final boards = rawBoards
        .map((rawBoard) => ImageBoardBoard.fromJson(rawBoard))
        .toList();

    var unescape = HtmlUnescape();
    for (var board in boards) {
      board.description = unescape.convert(board.description);
    }

    return boards;
  }
}
