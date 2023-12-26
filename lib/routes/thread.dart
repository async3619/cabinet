import 'package:cabinet/database/post.dart';
import 'package:cabinet/widgets/post_view.dart';
import 'package:flutter/material.dart';

class ThreadRoute extends StatefulWidget {
  const ThreadRoute({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<ThreadRoute> createState() => _ThreadRouteState();
}

class _ThreadRouteState extends State<ThreadRoute> {
  @override
  Widget build(BuildContext context) {
    var title = widget.post.title;
    title ??= "Thread #${widget.post.no!}";

    var posts = [widget.post, ...widget.post.children];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              PostView(post: posts[index]),
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
