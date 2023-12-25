import 'package:cabinet/api/post.dart';
import 'package:http/http.dart' as http;

import 'board.dart';

abstract class BaseApi<TBoard extends BaseBoard, TPost extends BasePost> {
  final http.Client client = http.Client();

  Future<List<TBoard>> getBoards();

  Future<List<TPost>> getOpeningPosts(String boardId);

  Future<List<TPost>> getChildPosts(String boardId, String openingPostId);
}
