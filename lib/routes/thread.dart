import 'package:cabinet/database/post.dart';
import 'package:cabinet/utils/unique.dart';
import 'package:cabinet/widgets/dialogs/post.dart';
import 'package:cabinet/widgets/modal/album.dart';
import 'package:cabinet/widgets/modal/media_viewer.dart';
import 'package:cabinet/widgets/post_view.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ThreadRoute extends StatefulWidget {
  const ThreadRoute({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<ThreadRoute> createState() => _ThreadRouteState();
}

class _ThreadRouteState extends State<ThreadRoute> {
  final AutoScrollController _controller = AutoScrollController();

  handleMediaIndexChanged(int mediaIndex) {
    final allPosts = [widget.post, ...widget.post.children];
    final imagePostIndex = <int>[];
    for (int i = 0; i < allPosts.length; i++) {
      final post = allPosts[i];
      imagePostIndex.addAll(post.images.map((_) => i));
    }

    _controller.scrollToIndex(imagePostIndex[mediaIndex],
        preferPosition: AutoScrollPosition.begin);
  }

  handleOpenAlbum() {
    var title = widget.post.title;
    title ??= 'Thread #${widget.post.no!}';

    final allPosts = [widget.post, ...widget.post.children];
    final images = allPosts
        .map((post) => post.images)
        .expand((images) => images)
        .toList()
        .unique((element) => element.md5);

    Navigator.of(context).push(AlbumModal(images: images, title: title));
  }

  handleShowMedia(Post post) {
    final allPosts = [widget.post, ...widget.post.children];
    final images =
        allPosts.map((post) => post.images).expand((images) => images).toList();

    final index = images
        .indexWhere((element) => element.id == post.images.firstOrNull?.id);
    if (index == -1) return;

    Navigator.of(context).push(MediaViewerModal(
        images: images,
        currentIndex: index,
        onIndexChanged: handleMediaIndexChanged));
  }

  handleRequestShowPost(List<int> postIds) {
    final allPosts = [widget.post, ...widget.post.children];
    final posts = allPosts.where((post) => postIds.contains(post.no)).toList();

    if (posts.isEmpty) return;

    showDialog(
        context: context,
        builder: (context) => PostDialog(posts: posts, allPosts: allPosts));
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.post.title;
    title ??= 'Thread #${widget.post.no!}';

    var posts = [widget.post, ...widget.post.children];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: handleOpenAlbum,
          ),
        ],
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return AutoScrollTag(
            key: ValueKey(index),
            controller: _controller,
            index: index,
            child: Column(
              children: [
                PostView(
                  post: posts[index],
                  onShowMedia: handleShowMedia,
                  onRequestShowPost: handleRequestShowPost,
                ),
                const Divider(
                  height: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
