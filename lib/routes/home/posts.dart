import 'package:flutter/material.dart';

class PostsTab extends StatefulWidget {
  static const title = 'Posts';

  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Posts'),
    );
  }
}
