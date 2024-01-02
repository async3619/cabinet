import 'dart:io';

import 'package:cabinet/database/repository/watcher.dart';
import 'package:darq/darq.dart';
import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:html/parser.dart';
import 'package:p_limit/p_limit.dart';

import 'base.dart';

typedef NewDataCallback = void Function(
    List<Post> newPosts, List<Image> newImages);

class WatcherTask extends BaseTask {
  final RepositoryHolder _repositoryHolder;
  final Watcher _watcher;
  final NewDataCallback? onNewData;

  WatcherTask({
    required RepositoryHolder repositoryHolder,
    required Watcher watcher,
    Function()? onDone,
    Function()? onStart,
    Function()? onComplete,
    Function(dynamic)? onError,
    this.onNewData,
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
        map['${post.board.target?.code}-${post.no}'] = post;
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
    final filteredPosts = <Post>[];

    for (var board in targetBoards) {
      final openingPosts =
          await _repositoryHolder.post.fetchOpeningPosts(board);

      if (_watcher.archived == true) {
        final archivedPostIds =
            await _repositoryHolder.post.fetchArchivedPostIds(board);

        final oldArchivedPosts = <Post>[];
        for (var postId in archivedPostIds) {
          final cachedPost = postMap['${board.code}-$postId'];
          if (cachedPost == null) {
            continue;
          }

          cachedPost.isArchived = true;
          oldArchivedPosts.add(cachedPost);
        }

        if (oldArchivedPosts.isNotEmpty) {
          await _repositoryHolder.post.saveAll(oldArchivedPosts);
        }

        final limit = PLimit<Post?>(Platform.numberOfProcessors * 2);
        final input = archivedPostIds.map((postId) => limit(() async {
              try {
                return await _repositoryHolder.post.fetchPost(board, postId);
              } catch (e) {
                return null;
              }
            }));

        final result = await Future.wait(input);
        final archivedPosts = result.whereType<Post>().toList();
        for (final post in archivedPosts) {
          post.isArchived = true;
        }

        openingPosts.addAll(archivedPosts);
      }

      for (var post in openingPosts) {
        if (!_watcher.isPostMatch(post)) {
          continue;
        }

        filteredPosts.add(post);
      }
    }

    /**
     * remove posts that are in blacklist
     */
    final blacklists = await _repositoryHolder.blacklist
        .findAll()
        .then((value) => value.map((e) => '${e.boardId}-${e.postId}').toList());

    filteredPosts.removeWhere((element) =>
        blacklists.contains('${element.board.target?.id}-${element.no}'));

    /**
     * get all child posts of filtered posts and get all images from opening posts and child posts.
     * then distinct the images and save them to database.
     *
     * finally, replace the image hashes in posts with the images from database.
     * and save the posts to database.
     */
    var images = <Image>[];
    var postsList = <List<Post>>[];
    final newPosts = <Post>[];
    for (var post in filteredPosts) {
      final childPosts = await _repositoryHolder.post.fetchChildPosts(post);
      final posts = [post, ...childPosts].map((e) {
        final cachedPost = postMap['${e.board.target?.code}-${e.no}'];
        if (cachedPost != null) {
          e.id = cachedPost.id;
        } else {
          newPosts.add(e);
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

    final newImages = List<Image>.from(images);
    if (onNewData != null) {
      onNewData!(newPosts, newImages);
    }

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

    /**
     * link replies to their parent posts
     */
    final allPosts = postsList.expand((element) => element).toList();
    final postIdMap = <int, Post>{};
    for (var post in allPosts) {
      postIdMap[post.no!] = post;
    }

    for (var post in allPosts) {
      final content = post.content;
      if (content == null) continue;

      final addedIds = <int>{};
      for (var replyParent in post.replyParent) {
        addedIds.add(replyParent.no!);
      }

      final document = parse(content);
      final quotelinks = document.querySelectorAll('.quotelink');
      for (var quotelink in quotelinks) {
        final href = quotelink.attributes['href'];
        if (href == null) continue;

        final rawId = href.substring(2);
        final id = int.tryParse(rawId);
        if (id == null) continue;

        final repliedPost = postIdMap[id];
        if (repliedPost == null) continue;

        if (addedIds.contains(id)) continue;

        addedIds.add(id);
        post.replyParent.add(repliedPost);
      }
    }

    await _repositoryHolder.post.saveAll(allPosts);

    await _repositoryHolder.watcher
        .setWatcherStatus(_watcher, WatcherStatus.idle);
  }

  @override
  void handleError(dynamic error) {
    _repositoryHolder.watcher.setWatcherStatus(_watcher, WatcherStatus.idle);
    super.handleError(error);
  }
}
