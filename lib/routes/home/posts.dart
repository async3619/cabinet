import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/objectbox.g.dart';
import 'package:cabinet/routes/thread.dart';
import 'package:cabinet/widgets/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  PostSortOrder _sortOrder = PostSortOrder.bumpOrder;
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();

    getPosts().then((posts) {
      if (!mounted) return;

      setState(() {
        _posts = posts;
      });
    });

    final holder = Provider.of<RepositoryHolder>(context, listen: false);
    holder.post.watch(Post_.parent.isNull()).listen((_) {
      getPosts().then((posts) {
        if (!mounted) return;

        setState(() {
          _posts = posts;
        });
      });
    });
  }

  Future<List<Post>> getPosts() async {
    final holder = Provider.of<RepositoryHolder>(context, listen: false);
    final posts = await holder.post.getOpeningPosts();

    return sortPosts(posts, _sortOrder);
  }

  List<Post> sortPosts(List<Post> posts, PostSortOrder order) {
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

  void handleOrderChanged(PostSortOrder value) {
    setState(() {
      _sortOrder = value;
      _posts = sortPosts(_posts!, value);
    });
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

    return GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        childAspectRatio: 3 / 5,
        children: List.generate(
            posts.length,
            (index) => PostListItem(
                post: posts[index],
                onCardTap: handleCardTap,
                onImageTap: (image) {})));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Posts"),
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
        Expanded(child: buildPostList())
      ],
    );
  }
}
