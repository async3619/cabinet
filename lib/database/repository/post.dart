import 'dart:convert';

import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/api/image_board/post.dart';
import 'package:cabinet/database/archived_post.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/objectbox.g.dart';

import 'base.dart';

class PostRepository extends BaseRepository<Post> {
  static Post _composePost(ImageBoardPost post, Board board) {
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
  }

  final ImageBoardApi _api;
  final Box<ArchivedPost> _archivedPostBox;

  PostRepository(
    this._api,
    Box<Post> box, {
    required Box<ArchivedPost> archivedPostBox,
  })  : _archivedPostBox = archivedPostBox,
        super(box);

  Future<Post> fetchPost(Board board, int postId) async {
    final archivedPost = await _archivedPostBox
        .query(
          ArchivedPost_.no
              .equals(postId)
              .and(ArchivedPost_.boardCode.equals(board.code!)),
        )
        .build()
        .findFirstAsync();

    List<ImageBoardPost> rawPosts;
    if (archivedPost == null) {
      rawPosts = await _api.getPosts(board.code!, postId.toString());
      if (rawPosts.isEmpty) {
        throw Exception('Post with id $postId not found');
      }

      if (rawPosts[0].archived == 1) {
        final archivedPost = ArchivedPost();
        archivedPost.boardCode = board.code!;
        archivedPost.no = postId;
        archivedPost.rawJson = jsonEncode(rawPosts);

        await _archivedPostBox.putAsync(archivedPost);
      }
    } else {
      rawPosts = (jsonDecode(archivedPost.rawJson!) as List<dynamic>)
          .map(
            (rawPost) => ImageBoardPost.fromJson(rawPost),
          )
          .toList();
    }

    return _composePost(rawPosts[0], board);
  }

  Future<List<int>> fetchArchivedPostIds(Board board) async {
    return _api.getArchivedPostIds(board.code!);
  }

  Future<List<Post>> fetchOpeningPosts(Board board) async {
    var rawPosts = await _api.getOpeningPosts(board.code!);
    var posts = rawPosts.map((post) => _composePost(post, board)).toList();

    return posts;
  }

  Future<List<Post>> fetchChildPosts(Post parent) async {
    final boardCode = parent.board.target!.code!;
    final archivedPost = await _archivedPostBox
        .query(
          ArchivedPost_.no
              .equals(parent.no!)
              .and(ArchivedPost_.boardCode.equals(boardCode)),
        )
        .build()
        .findFirstAsync();

    List<ImageBoardPost> rawPosts;
    if (archivedPost == null) {
      rawPosts = await _api.getChildPosts(boardCode, parent.no.toString());
    } else {
      rawPosts = (jsonDecode(archivedPost.rawJson!) as List<dynamic>)
          .map(
            (rawPost) => ImageBoardPost.fromJson(rawPost),
          )
          .toList()
          .sublist(1);
    }

    var posts = rawPosts
        .map((post) =>
            _composePost(post, parent.board.target!)..parent.target = parent)
        .toList();

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

  Stream<Query<Post>> watchOpeningPosts({bool triggerImmediately = false}) {
    return box
        .query(Post_.parent.equals(0))
        .watch(triggerImmediately: triggerImmediately);
  }
}
