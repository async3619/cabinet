import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/objectbox.g.dart';

class PostRepository {
  final ImageBoardApi _api;
  final Box<Post> box;

  PostRepository(this._api, this.box);

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

      if (post.filename != null) {
        entity.images.add(Image(
            post.filename,
            post.extension,
            post.width,
            post.height,
            post.thumbnailWidth,
            post.thumbnailHeight,
            post.imageTime,
            post.imageSize,
            post.imageMd5));
      }

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

      if (post.filename != null) {
        entity.images.add(Image(
            post.filename,
            post.extension,
            post.width,
            post.height,
            post.thumbnailWidth,
            post.thumbnailHeight,
            post.imageTime,
            post.imageSize,
            post.imageMd5));
      }

      return entity;
    }).toList();

    return posts;
  }

  Future<Map<int, Post>> getPostsByPostIds(List<int> postIds) async {
    final posts = await box.getAllAsync();
    final postMap = <int, Post>{};
    for (var post in posts) {
      postMap[post.no!] = post;
    }

    return postMap;
  }

  Future<T> save<T>(T postOrPosts) async {
    if (postOrPosts is Post) {
      final id = await box.putAsync(postOrPosts);
      postOrPosts.id = id;

      return postOrPosts;
    }

    if (postOrPosts is List<Post>) {
      final ids = await box.putManyAsync(postOrPosts);
      for (var i = 0; i < ids.length; i++) {
        postOrPosts[i].id = ids[i];
      }

      return postOrPosts;
    }

    throw Exception('Invalid type');
  }
}
