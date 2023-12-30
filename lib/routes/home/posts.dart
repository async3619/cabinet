import 'package:cabinet/database/board.dart';
import 'package:collection/collection.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:cabinet/routes/thread.dart';
import 'package:cabinet/widgets/post_list_item.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const selectedWatcherIdKey = 'selectedWatcherId';
const selectedBoardIdKey = 'selectedBoardId';
const selectedFilteredByKey = 'selectedFilteredBy';

enum PostSortOrder {
  bumpOrder,
  replyCount,
  imageCount,
  newest,
  oldest,
}

enum PostFilteredBy {
  watcher,
  board,
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

  List<Post>? _posts;

  PostFilteredBy _filteredBy = PostFilteredBy.watcher;
  PostSortOrder _sortOrder = PostSortOrder.bumpOrder;

  List<Board>? _boards;
  Board? _selectedBoard;

  List<Watcher>? _watchers;
  Watcher? _selectedWatcher;

  @override
  void initState() {
    super.initState();

    final holder = Provider.of<RepositoryHolder>(context, listen: false);

    (() async {
      final prefs = await SharedPreferences.getInstance();
      final selectedWatcherId = prefs.getInt(selectedWatcherIdKey);
      final selectedBoardId = prefs.getInt(selectedBoardIdKey);
      final selectedFilteredBy = prefs.getInt(selectedFilteredByKey);
      final posts = await holder.post.getOpeningPosts();

      setState(() {
        _watchers = holder.watcher.box.getAll();
        _boards = posts
            .map((e) => e.board.target)
            .whereNotNull()
            .distinct((b) => b.id)
            .toList();

        _posts = sortPosts(posts, _sortOrder);
        _filteredBy = selectedFilteredBy == null
            ? PostFilteredBy.watcher
            : PostFilteredBy.values[selectedFilteredBy];

        if (selectedWatcherId != null) {
          _selectedWatcher = holder.watcher.box.get(selectedWatcherId);
        } else {
          _selectedWatcher = null;
        }

        if (selectedBoardId != null) {
          _selectedBoard = holder.board.box.get(selectedBoardId);
        } else {
          _selectedBoard = null;
        }
      });
    })();
  }

  void switchFilteredBy() {
    final newFilteredBy = _filteredBy == PostFilteredBy.watcher
        ? PostFilteredBy.board
        : PostFilteredBy.watcher;

    (() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(selectedFilteredByKey, newFilteredBy.index);
    })();

    setState(() {
      _filteredBy = newFilteredBy;
    });
  }

  bool filterPostByWatcher(Post post) {
    final selectedWatcher = _selectedWatcher;
    if (selectedWatcher == null) {
      return true;
    }

    return selectedWatcher.isPostMatch(post);
  }

  bool filterPostByBoard(Post post) {
    final selectedBoard = _selectedBoard;
    if (selectedBoard == null) {
      return true;
    }

    return post.board.targetId == selectedBoard.id;
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

  void handleBoardChanged(int? boardId) {
    (() async {
      final prefs = await SharedPreferences.getInstance();
      final boards = _boards;
      if (boards == null) {
        return;
      }

      if (boardId == null) {
        prefs.remove(selectedBoardIdKey);
      } else {
        prefs.setInt(selectedBoardIdKey, boardId);
      }

      setState(() {
        _selectedBoard =
            boards.firstWhereOrNull((element) => element.id == boardId);
      });
    })();
  }

  void handleCardTap(Post post) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ThreadRoute(post: post)));
  }

  Widget buildFilterDropdown() {
    List<DropdownMenuItem<int>> items = [];
    if (_filteredBy == PostFilteredBy.watcher && _watchers != null) {
      for (final watcher in _watchers!) {
        items.add(DropdownMenuItem(
          value: watcher.id,
          child: Text(watcher.name!),
        ));
      }
    } else if (_boards != null) {
      for (final board in _boards!) {
        items.add(DropdownMenuItem(
          value: board.id,
          child: Text(board.name),
        ));
      }
    }

    return DropdownButton<int>(
        value: _filteredBy == PostFilteredBy.watcher
            ? _selectedWatcher?.id
            : _selectedBoard?.id,
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text('All'),
          ),
          ...items,
        ],
        onChanged: (value) {
          if (_filteredBy == PostFilteredBy.watcher) {
            handleWatcherChanged(value);
          } else {
            handleBoardChanged(value);
          }
        });
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

    final filter = _filteredBy == PostFilteredBy.watcher
        ? filterPostByWatcher
        : filterPostByBoard;

    final filteredPosts = posts.where(filter).toList();

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

    final filterIcon = _filteredBy == PostFilteredBy.watcher
        ? const Icon(Icons.folder_copy)
        : const Icon(Icons.remove_red_eye);

    return Column(
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: _posts == null ? Container() : buildFilterDropdown(),
          actions: [
            IconButton(onPressed: switchFilteredBy, icon: filterIcon),
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
