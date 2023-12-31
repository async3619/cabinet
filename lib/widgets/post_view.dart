import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/utils/debouncer.dart';
import 'package:cabinet/widgets/dynamic_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

TextStyle descriptionText(BuildContext context, int? alpha) {
  alpha ??= 128;

  return TextStyle(
    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(alpha),
  );
}

class PostView extends StatelessWidget {
  static final Debouncer _readDebouncer = Debouncer(milliseconds: 750);

  const PostView({
    Key? key,
    required this.post,
    this.onRequestShowPost,
    this.onShowMedia,
  }) : super(key: key);

  final Post post;
  final Function(List<int> postIds)? onRequestShowPost;
  final Function(Post post)? onShowMedia;

  handleRepliesTap() {
    if (onRequestShowPost == null) return;

    onRequestShowPost?.call(post.replies.map((e) => e.no!).toList());
  }

  handleVisibilityChanged(VisibilityInfo info, BuildContext context) {
    _readDebouncer.run(() async {
      if (info.visibleFraction != 1) {
        return;
      }

      final parent = post.parent.target;
      if (parent == null) return;

      final children = [parent, ...parent.children.toList()];
      children.removeWhere((element) => element.id > post.id);

      if (children.isEmpty) return;

      final repositoryHolder =
          Provider.of<RepositoryHolder>(context, listen: false);

      for (var post in children) {
        post.isRead = true;
      }

      repositoryHolder.post.saveAll(children);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryImage = post.images.firstOrNull;
    final descriptionTextStyle = descriptionText(context, 128);

    final postMetadata = [
      'No.${post.no}',
      DateFormat('yyyy-MM-dd HH:mm:ss').format(post.createdAt!),
    ].join(' ');

    String? primaryImageMetadata;
    if (primaryImage != null) {
      final filename = primaryImage.filename!;
      final extension = primaryImage.extension!;

      primaryImageMetadata = [
        '$filename$extension',
        if (primaryImage.size != null) filesize(primaryImage.size!),
        if (primaryImage.width != null && primaryImage.height != null)
          '${primaryImage.width}x${primaryImage.height}',
      ].join(' ');
    }

    final thumbnailUrl = post.thumbnailUrl;
    final isPrimaryMediaVideo = post.images.firstOrNull?.extension == '.webm';

    return VisibilityDetector(
        key: Key(post.id.toString()),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thumbnailUrl != null)
              SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: DynamicImage(
                              image: primaryImage, fit: BoxFit.cover)),
                      if (isPrimaryMediaVideo)
                        Positioned.fill(
                            child: Center(
                          child: Icon(Icons.play_circle_outline,
                              size: 24,
                              color: Theme.of(context).colorScheme.onSurface),
                        )),
                      Positioned.fill(
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (onShowMedia != null) {
                                    onShowMedia!(post);
                                  }
                                },
                              ))),
                    ],
                  )),
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.title != null)
                    Text(post.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  if (post.title != null) const SizedBox(height: 2),
                  Row(children: [
                    if (post.author != null)
                      Text(
                        post.author!,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: descriptionText(context, 255),
                      ),
                    if (post.author != null)
                      Text(
                        ' ',
                        style: descriptionTextStyle,
                      ),
                    Expanded(
                        child: Text(
                      postMetadata,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: descriptionTextStyle,
                    )),
                  ]),
                  if (primaryImageMetadata != null)
                    Text(
                      primaryImageMetadata,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: descriptionTextStyle,
                    ),
                  const SizedBox(height: 8),
                  Html(
                      data: post.content ?? '',
                      onAnchorTap: (url, _, __) {
                        if (url == null) return;

                        if (url.startsWith('#p')) {
                          final postId = int.tryParse(url.substring(2));
                          if (postId != null && onRequestShowPost != null) {
                            onRequestShowPost!([postId]);
                          }
                        }
                      },
                      style: {
                        'body': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          fontSize: FontSize(Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize ??
                              14),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        'a': Style(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        '.quote': Style(
                          color: const Color(0xFFB5BD68),
                        ),
                      }),
                  if (post.replyCount > 0) const SizedBox(height: 8),
                  if (post.replyCount > 0)
                    InkWell(
                        onTap: handleRepliesTap,
                        child: Text(
                          '${post.replyCount} replies',
                          style: descriptionTextStyle,
                        )),
                ],
              ),
            ))
          ],
        ),
        onVisibilityChanged: (info) => handleVisibilityChanged(info, context));
  }
}
