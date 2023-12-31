import 'package:cabinet/database/repository/watcher.dart';
import 'package:darq/darq.dart';
import 'package:cabinet/database/filter.dart';
import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/watcher.dart';

import 'base.dart';

class WatcherTask extends BaseTask {
  final RepositoryHolder _repositoryHolder;
  final Watcher _watcher;

  WatcherTask({
    required RepositoryHolder repositoryHolder,
    required Watcher watcher,
    Function()? onDone,
    Function()? onStart,
    Function()? onComplete,
    Function(dynamic)? onError,
  })  : _repositoryHolder = repositoryHolder,
        _watcher = watcher,
        super(
          onDone: onDone,
          onStart: onStart,
          onComplete: onComplete,
          onError: onError,
        );

  @override
  Future<void> doTask() async {
    await _repositoryHolder.watcher
        .setWatcherStatus(_watcher, WatcherStatus.running);

    final postMap = await _repositoryHolder.post.findAll().then((value) {
      final Map<String, Post> map = {};
      for (var post in value) {
        map["${post.board.target?.code}-${post.no}"] = post;
      }

      return map;
    });

    final Map<String, Image> imageMap =
        await _repositoryHolder.image.findAll().then((value) {
      final Map<String, Image> map = {};
      for (var image in value) {
        map[image.md5!] = image;
      }

      return map;
    });

    /**
     * filter out posts that match the filter
     */
    final targetBoards = _watcher.boards.toList();
    final filters = _watcher.filters.toList();
    final filteredPosts = <Post>[];

    for (var board in targetBoards) {
      final openingPosts =
          await _repositoryHolder.post.fetchOpeningPosts(board);

      for (var post in openingPosts) {
        for (var filter in filters) {
          if (!_checkFilter(post, filter)) {
            continue;
          }

          filteredPosts.add(post);
        }
      }
    }

    /**
     * remove posts that are in blacklist
     */
    final blacklists = await _repositoryHolder.blacklist
        .findAll()
        .then((value) => value.map((e) => "${e.boardId}-${e.postId}").toList());

    filteredPosts.removeWhere((element) =>
        blacklists.contains("${element.board.target?.id}-${element.no}"));

    /**
     * get all child posts of filtered posts and get all images from opening posts and child posts.
     * then distinct the images and save them to database.
     *
     * finally, replace the image hashes in posts with the images from database.
     * and save the posts to database.
     */
    var images = <Image>[];
    var postsList = <List<Post>>[];
    for (var post in filteredPosts) {
      final childPosts = await _repositoryHolder.post.fetchChildPosts(post);
      final posts = [post, ...childPosts].map((e) {
        final cachedPost = postMap["${e.board.target?.code}-${e.no}"];
        if (cachedPost != null) {
          e.id = cachedPost.id;
        }

        return e;
      }).toList();

      postsList.add(posts);
      images.addAll(posts.expand((element) => element.images));
    }

    images = images
        .distinct((element) => element.md5!)
        .where((element) => !imageMap.containsKey(element.md5!))
        .toList();

    await _repositoryHolder.image.box.putManyAsync(images).then((ids) {
      for (var i = 0; i < images.length; i++) {
        images[i].id = ids[i];
        imageMap[images[i].md5!] = images[i];
      }
    });

    for (var posts in postsList) {
      for (var post in posts) {
        final oldHashes = post.images.map((e) => e.md5!).toList();

        post.images.clear();
        post.images.addAll(oldHashes.map((e) => imageMap[e]!));
      }
    }

    await _repositoryHolder.post
        .saveAll(postsList.expand((element) => element).toList());

    await _repositoryHolder.watcher
        .setWatcherStatus(_watcher, WatcherStatus.idle);
  }

  bool _checkFilter(Post post, Filter filter) {
    final shouldCheckTitle = filter.location == SearchLocation.subject ||
        filter.location == SearchLocation.subjectContent;
    final shouldCheckContent = filter.location == SearchLocation.content ||
        filter.location == SearchLocation.subjectContent;

    final title = post.title;
    final content = post.content;
    final caseSensitive = filter.caseSensitive ?? false;

    if (shouldCheckTitle && title != null) {
      if (caseSensitive && title.contains(filter.keyword!)) {
        return true;
      }

      if (!caseSensitive &&
          title.toLowerCase().contains(filter.keyword!.toLowerCase())) {
        return true;
      }
    }

    if (shouldCheckContent && content != null) {
      if (caseSensitive && content.contains(filter.keyword!)) {
        return true;
      }

      if (!caseSensitive &&
          content.toLowerCase().contains(filter.keyword!.toLowerCase())) {
        return true;
      }
    }

    return false;
  }
}
