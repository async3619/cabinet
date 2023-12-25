import 'package:cabinet/database/filter.dart';
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
    /**
     * filter out posts that match the filter
     */
    final targetBoards = _watcher.boards.toList();
    final filters = _watcher.filters.toList();
    final filteredPosts = <Post>[];

    for (var board in targetBoards) {
      final openingPosts =
          await _repositoryHolder.post.fetchOpeningPosts(board);

      for (var value in openingPosts) {
        for (var filter in filters) {
          if (!_checkFilter(value, filter)) {
            continue;
          }

          filteredPosts.add(value);
        }
      }
    }

    /**
     * save opening posts into database
     */
    var dbPosts = await _repositoryHolder.post.getPostsByPostIds(
      filteredPosts.map((e) => e.no!).toList(),
    );

    var newPosts = <Post>[];
    for (var post in filteredPosts) {
      final originalPost = dbPosts[post.no!];
      if (originalPost != null) {
        continue;
      }

      newPosts.add(post);
    }

    await _repositoryHolder.post.save(newPosts);

    /**
     * save child posts into database
     */
    for (var post in filteredPosts) {
      final childPosts = await _repositoryHolder.post.fetchChildPosts(post);
      final childDbPosts = await _repositoryHolder.post.getPostsByPostIds(
        childPosts.map((e) => e.no!).toList(),
      );

      final newPosts = <Post>[];
      for (var childPost in childPosts) {
        final originalPost = childDbPosts[childPost.no!];
        if (originalPost != null) {
          continue;
        }

        newPosts.add(childPost);
      }

      await _repositoryHolder.post.save(newPosts);
    }
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
