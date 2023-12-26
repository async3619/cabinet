import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/objectbox.g.dart';

import 'base.dart';

class PostRepository extends BaseRepository<Post> {
  final ImageBoardApi _api;

  PostRepository(this._api, Box<Post> box) : super(box);

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
          post.imageMd5,
          'https://i.4cdn.org/${board.code}/${post.imageTime}${post.extension}',
          'https://i.4cdn.org/${board.code}/${post.imageTime}s.jpg',
        ));
      }

      return entity;
    }).toList();

    return posts;
  }

  Future<List<Post>> fetchChildPosts(Post parent) async {
    final boardCode = parent.board.target!.code!;
    var rawPosts = await _api.getChildPosts(boardCode, parent.no.toString());

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
          post.imageMd5,
          'https://i.4cdn.org/$boardCode/${post.imageTime}${post.extension}',
          'https://i.4cdn.org/$boardCode/${post.imageTime}s.jpg',
        ));
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

  Future<List<Post>> getOpeningPosts() async {
    return box.query(Post_.parent.equals(0)).build().find();
  }
}
