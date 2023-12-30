import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/image.dart' as db_image;
import 'package:cabinet/widgets/dynamic_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  final Function(db_image.Image)? onImageTap;
  final Function(Post)? onCardTap;

  const PostListItem({
    Key? key,
    required this.post,
    this.onImageTap,
    this.onCardTap,
  }) : super(key: key);

  void handleImageTap(db_image.Image image) {
    if (onImageTap != null) {
      onImageTap!(image);
    }
  }

  void handleCardTap() {
    if (onCardTap != null) {
      onCardTap!(post);
    }
  }

  Widget? buildThumbnail(BuildContext context) {
    final thumbnailUrl = post.thumbnailUrl;
    final image = post.images.firstOrNull;
    if (thumbnailUrl == null || image == null) {
      return null;
    }

    return AspectRatio(
        aspectRatio: 16 / 11,
        child: Stack(
          children: [
            Positioned.fill(
                child: DynamicImage(image: image, fit: BoxFit.cover)),
            Positioned.fill(
                child: Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 36,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
              ),
            )),
            Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        handleImageTap(image);
                      },
                    )))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = buildThumbnail(context);
    final title = post.title;
    final document = parse(post.content?.replaceAll("<br>", "\n") ?? "");
    final content = parse(document.body?.text).documentElement?.text;

    final bodyTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thumbnail != null) thumbnail,
            Expanded(
                child: Material(
                    color: Theme.of(context).cardColor,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (title != null)
                                  Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                if (title != null) const SizedBox(height: 4),
                                if (content != null)
                                  Text(
                                    content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: bodyTextStyle,
                                  )
                              ]),
                        )),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Theme.of(context).cardColor,
                            child: Text(
                              '${post.replyCount}R ${post.imageCount}I',
                              style: bodyTextStyle,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    handleCardTap();
                                  },
                                )))
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
