import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/widgets/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsTab extends StatefulWidget {
  static const title = 'Posts';

  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  @override
  Widget build(BuildContext context) {
    final holder = Provider.of<RepositoryHolder>(context, listen: false);

    return FutureBuilder(
        future: holder.post.getOpeningPosts(),
        builder: (context, snapshot) {
          final posts = snapshot.data;
          if (!snapshot.hasData || posts == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 3 / 5,
            children: List.generate(
                posts.length,
                (index) => PostListItem(
                    post: posts[index],
                    onCardTap: (post) {
                      print("Card tapped: $post");
                    },
                    onImageTap: (image) {
                      print("Image tapped: $image");
                    })),
          );
        });
  }
}
