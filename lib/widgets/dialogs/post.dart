import 'package:cabinet/database/post.dart';
import 'package:cabinet/widgets/modal/media_viewer.dart';
import 'package:cabinet/widgets/post_view.dart';
import 'package:flutter/material.dart';

class PostDialog extends StatefulWidget {
  const PostDialog({
    Key? key,
    required this.posts,
    required this.allPosts,
  }) : super(key: key);

  final List<Post> posts;
  final List<Post> allPosts;

  @override
  State<PostDialog> createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  List<List<Post>> _postHistory = [];

  @override
  void initState() {
    super.initState();
    _postHistory = [widget.posts];
  }

  void handleShowMedia(Post post) {
    final images = widget.allPosts
        .map((post) => post.images)
        .expand((images) => images)
        .toList();

    final index = images
        .indexWhere((element) => element.id == post.images.firstOrNull?.id);
    if (index == -1) return;

    Navigator.of(context)
        .push(MediaViewerModal(images: images, currentIndex: index));
  }

  void handleRequestShowPost(List<int> postIds) {
    final posts =
        widget.allPosts.where((post) => postIds.contains(post.no)).toList();
    if (posts.isEmpty) return;

    setState(() {
      _postHistory.add(posts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = _postHistory.lastOrNull;
    if (post == null) return const SizedBox();

    return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Row(
          children: [
            Expanded(
                child: InkWell(
                    onTap: () {
                      if (_postHistory.length > 1) {
                        setState(() {
                          _postHistory.removeLast();
                        });
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chevron_left),
                          const SizedBox(width: 8),
                          Text(
                            'Back',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ))),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.close),
                          const SizedBox(width: 8),
                          Text(
                            'Close',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ))),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(height: 1),
                  for (final post in post)
                    Column(
                      children: [
                        PostView(
                          post: post,
                          onShowMedia: handleShowMedia,
                          onRequestShowPost: handleRequestShowPost,
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    ),
                ],
              ),
            )));
  }
}
