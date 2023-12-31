import 'dart:convert';
import 'package:cabinet/api/image_board/post.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:cabinet/api/base.dart';

import 'board.dart';

class ImageBoardApi extends BaseApi<ImageBoardBoard, ImageBoardPost> {
  final unescape = HtmlUnescape();
  final String baseUrl;

  ImageBoardApi({required this.baseUrl});

  Future<List<int>> getArchivedPostIds(String boardId) async {
    final response =
        await client.get(Uri.parse('$baseUrl/$boardId/archive.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load archived post ids');
    }

    return (jsonDecode(response.body) as List<dynamic>).cast();
  }

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

    for (var board in boards) {
      board.description = unescape.convert(board.description);
    }

    return boards;
  }

  @override
  Future<List<ImageBoardPost>> getOpeningPosts(String boardId) async {
    var response =
        await client.get(Uri.parse('$baseUrl/$boardId/catalog.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load opening posts');
    }

    final rawResponse = jsonDecode(response.body) as List<dynamic>;
    final rawPosts = rawResponse
        .map((rawPage) => rawPage['threads'] as List<dynamic>)
        .expand((element) => element)
        .toList();

    final posts =
        rawPosts.map((rawPost) => ImageBoardPost.fromJson(rawPost)).toList();

    for (var post in posts) {
      if (post.title != null) {
        post.title = unescape.convert(post.title!);
      }

      if (post.content != null) {
        post.content = unescape.convert(post.content!);
      }
    }

    return posts;
  }

  Future<List<ImageBoardPost>> getPosts(
      String boardId, String openingPostId) async {
    var response = await client
        .get(Uri.parse('$baseUrl/$boardId/thread/$openingPostId.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load child posts');
    }

    final rawResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final rawPosts = rawResponse['posts'] as List<dynamic>;
    final posts =
        rawPosts.map((rawPost) => ImageBoardPost.fromJson(rawPost)).toList();

    for (var post in posts) {
      if (post.title != null) {
        post.title = unescape.convert(post.title!);
      }

      if (post.content != null) {
        post.content = unescape.convert(post.content!);
      }
    }

    return posts;
  }

  @override
  Future<List<ImageBoardPost>> getChildPosts(
      String boardId, String openingPostId) async {
    final list = await getPosts(boardId, openingPostId);

    return list.sublist(1);
  }
}
