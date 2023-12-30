import 'package:collection/collection.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:cabinet/routes/thread.dart';
import 'package:cabinet/widgets/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const selectedWatcherIdKey = 'selectedWatcherId';

enum PostSortOrder {
  bumpOrder,
  replyCount,
  imageCount,
  newest,
  oldest,
}

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  static List<Post> sortPosts(List<Post> posts, PostSortOrder order) {
    final copiedPosts = List<Post>.from(posts);
    switch (order) {
      case PostSortOrder.bumpOrder:
        copiedPosts.sort((a, b) {
          final left = a.children.lastOrNull ?? a;
          final right = b.children.lastOrNull ?? b;

          return right.createdAt!.millisecondsSinceEpoch
              .compareTo(left.createdAt!.millisecondsSinceEpoch);
        });
        break;

      case PostSortOrder.replyCount:
        copiedPosts.sort((a, b) => b.replyCount.compareTo(a.replyCount));
        break;

      case PostSortOrder.imageCount:
        copiedPosts.sort((a, b) => b.imageCount.compareTo(a.imageCount));
        break;

      case PostSortOrder.newest:
        copiedPosts.sort((a, b) => b.createdAt!.millisecondsSinceEpoch
            .compareTo(a.createdAt!.millisecondsSinceEpoch));
        break;

      case PostSortOrder.oldest:
        copiedPosts.sort((a, b) => a.createdAt!.millisecondsSinceEpoch
            .compareTo(b.createdAt!.millisecondsSinceEpoch));
        break;
    }

    return copiedPosts;
  }

  PostSortOrder _sortOrder = PostSortOrder.bumpOrder;
  List<Post>? _posts;

  List<Watcher>? _watchers;
  Watcher? _selectedWatcher;

  @override
  void initState() {
    super.initState();

    final holder = Provider.of<RepositoryHolder>(context, listen: false);

    (() async {
      final prefs = await SharedPreferences.getInstance();
      final selectedWatcherId = prefs.getInt(selectedWatcherIdKey);
      final posts = await holder.post.getOpeningPosts();

      setState(() {
        _watchers = holder.watcher.box.getAll();
        _posts = sortPosts(posts, _sortOrder);

        if (selectedWatcherId != null) {
          _selectedWatcher = holder.watcher.box.get(selectedWatcherId);
        } else {
          _selectedWatcher = null;
        }
      });
    })();
  }

  bool filterPostByWatcher(Post post) {
    final selectedWatcher = _selectedWatcher;
    if (selectedWatcher == null) {
      return true;
    }

    return selectedWatcher.isPostMatch(post);
  }

  void handleOrderChanged(PostSortOrder value) {
    setState(() {
      _sortOrder = value;
      _posts = sortPosts(_posts!, value);
    });
  }

  void handleWatcherChanged(int? watcherId) {
    (() async {
      final prefs = await SharedPreferences.getInstance();
      final watchers = _watchers;
      if (watchers == null) {
        return;
      }

      if (watcherId == null) {
        prefs.remove(selectedWatcherIdKey);
      } else {
        prefs.setInt(selectedWatcherIdKey, watcherId);
      }

      setState(() {
        _selectedWatcher =
            watchers.firstWhereOrNull((element) => element.id == watcherId);
      });
    })();
  }

  void handleCardTap(Post post) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ThreadRoute(post: post)));
  }

  PopupMenuItem<PostSortOrder> buildPopupMenuItem(
      PostSortOrder value, String text) {
    if (_sortOrder == value) {
      text = '✓ $text';
    }

    return PopupMenuItem(
      value: value,
      child: Text(text),
    );
  }

  Widget buildPostList() {
    final posts = _posts;
    if (posts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredPosts = posts.where(filterPostByWatcher).toList();

    return GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        childAspectRatio: 3 / 5,
        children: List.generate(
            filteredPosts.length,
            (index) => PostListItem(
                post: filteredPosts[index],
                onCardTap: handleCardTap,
                onImageTap: (image) {})));
  }

  @override
  Widget build(BuildContext context) {
    Widget postList;
    final watchers = _watchers;
    if (watchers == null) {
      postList = const Center(child: CircularProgressIndicator());
    } else {
      postList = buildPostList();
    }

    Widget title = DropdownButton<int>(
      value: _selectedWatcher?.id,
      onChanged: handleWatcherChanged,
      items: [
        if (watchers != null)
          const DropdownMenuItem(
            value: null,
            child: Text('All'),
          ),
        if (watchers != null)
          for (final watcher in watchers)
            DropdownMenuItem(
              value: watcher.id,
              child: Text(watcher.name!),
            )
      ],
    );

    return Column(
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: title,
          actions: [
            PopupMenuButton(
              onSelected: handleOrderChanged,
              icon: const Icon(Icons.sort),
              itemBuilder: (context) => [
                buildPopupMenuItem(PostSortOrder.bumpOrder, 'Bump Order'),
                buildPopupMenuItem(PostSortOrder.replyCount, 'Reply Count'),
                buildPopupMenuItem(PostSortOrder.imageCount, 'Image Count'),
                buildPopupMenuItem(PostSortOrder.newest, 'Newest'),
                buildPopupMenuItem(PostSortOrder.oldest, 'Oldest'),
              ],
            )
          ],
        ),
        Expanded(child: postList)
      ],
    );
  }
}
