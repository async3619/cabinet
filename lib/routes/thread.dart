import 'package:cabinet/database/post.dart';
import 'package:cabinet/widgets/dialogs/post.dart';
import 'package:cabinet/widgets/modal/album.dart';
import 'package:cabinet/widgets/modal/media_viewer.dart';
import 'package:cabinet/widgets/post_view.dart';
import 'package:flutter/material.dart';

class ThreadRoute extends StatefulWidget {
  const ThreadRoute({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<ThreadRoute> createState() => _ThreadRouteState();
}

class _ThreadRouteState extends State<ThreadRoute> {
  handleOpenAlbum() {
    var title = widget.post.title;
    title ??= 'Thread #${widget.post.no!}';

    final allPosts = [widget.post, ...widget.post.children];
    final images =
        allPosts.map((post) => post.images).expand((images) => images).toList();

    Navigator.of(context).push(AlbumModal(images: images, title: title));
  }

  handleShowMedia(Post post) {
    final allPosts = [widget.post, ...widget.post.children];
    final images =
        allPosts.map((post) => post.images).expand((images) => images).toList();

    final index = images
        .indexWhere((element) => element.id == post.images.firstOrNull?.id);
    if (index == -1) return;

    Navigator.of(context)
        .push(MediaViewerModal(images: images, currentIndex: index));
  }

  handleRequestShowPost(int postId) {
    final allPosts = [widget.post, ...widget.post.children];
    final post = allPosts.where((element) => element.no == postId).firstOrNull;
    if (post == null) return;

    showDialog(
        context: context,
        builder: (context) => PostDialog(post: post, allPosts: allPosts));
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
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Column(
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
          );
        },
      ),
    );
  }
}
