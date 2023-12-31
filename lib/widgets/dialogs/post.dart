import 'package:cabinet/database/post.dart';
import 'package:cabinet/widgets/modal/media_viewer.dart';
import 'package:cabinet/widgets/post_view.dart';
import 'package:flutter/material.dart';

class PostDialog extends StatefulWidget {
  const PostDialog({
    Key? key,
    required this.post,
    required this.allPosts,
  }) : super(key: key);

  final Post post;
  final List<Post> allPosts;

  @override
  State<PostDialog> createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  List<Post> postHistory = [];

  @override
  void initState() {
    super.initState();
    postHistory = [widget.post];
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

  void handleRequestShowPost(int postId) {
    final post =
        widget.allPosts.where((element) => element.no == postId).firstOrNull;
    if (post == null) return;

    setState(() {
      postHistory.add(post);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = postHistory.lastOrNull;
    if (post == null) return const SizedBox();

    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              if (postHistory.length > 1) {
                                setState(() {
                                  postHistory.removeLast();
                                });
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chevron_left),
                                  SizedBox(width: 8),
                                  Text(
                                    'Back',
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
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.close),
                                  SizedBox(width: 8),
                                  Text(
                                    'Close',
                                  )
                                ],
                              ),
                            ))),
                  ],
                ),
                const Divider(height: 1),
                PostView(
                  post: post,
                  onShowMedia: handleShowMedia,
                  onRequestShowPost: handleRequestShowPost,
                )
              ],
            ),
          ),
        ));
  }
}
