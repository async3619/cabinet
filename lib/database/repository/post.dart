import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/objectbox.g.dart';

class PostRepository {
  final ImageBoardApi _api;
  final Box<Post> _box;

  PostRepository(this._api, this._box);

  Future<List<Post>> fetchOpeningPosts(Board board) async {
    var rawPosts = await _api.getOpeningPosts(board.code!);
    var posts = rawPosts.map((post) {
      final entity = Post();
      entity.no = post.id;
      entity.title = post.title;
      entity.content = post.content;
      entity.author = post.author;
      entity.createdAt = post.createdAt;
      entity.board.target = board;

      return entity;
    }).toList();

    return posts;
  }

  Future<List<Post>> fetchChildPosts(Post parent) async {
    var rawPosts = await _api.getChildPosts(
        parent.board.target!.code!, parent.no.toString());

    var posts = rawPosts.map((post) {
      final entity = Post();
      entity.no = post.id;
      entity.title = post.title;
      entity.content = post.content;
      entity.author = post.author;
      entity.createdAt = post.createdAt;
      entity.board.target = parent.board.target;
      entity.parent.target = parent;

      return entity;
    }).toList();

    return posts;
  }

  Future<Map<int, Post>> getPostsByPostIds(List<int> postIds) async {
    var result = await _box
        .query(
          Post_.no.oneOf(postIds),
        )
        .build()
        .findAsync();

    return {for (var e in result) e.no!: e};
  }

  Future<void> save<T>(T postOrPosts) {
    if (postOrPosts is Post) {
      return _box.putAsync(postOrPosts);
    }

    if (postOrPosts is List<Post>) {
      return _box.putManyAsync(postOrPosts);
    }

    throw Exception('Invalid type');
  }
}
