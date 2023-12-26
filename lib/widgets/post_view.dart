import 'package:cabinet/database/post.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

TextStyle descriptionText(BuildContext context, int? alpha) {
  alpha ??= 128;

  return TextStyle(
    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(alpha),
  );
}

class PostView extends StatelessWidget {
  const PostView({
    Key? key,
    required this.post,
    this.onRequestShowPost,
  }) : super(key: key);

  final Post post;
  final Function(int postId)? onRequestShowPost;

  @override
  Widget build(BuildContext context) {
    final primaryImage = post.images.firstOrNull;
    final descriptionTextStyle = descriptionText(context, 128);

    final postMetadata = [
      "No.${post.no}",
      DateFormat('yyyy-MM-dd HH:mm:ss').format(post.createdAt!),
    ].join(" ");

    String? primaryImageMetadata;
    if (primaryImage != null) {
      final filename = primaryImage.filename!;
      final extension = primaryImage.extension!;

      primaryImageMetadata = [
        "$filename$extension",
        if (primaryImage.size != null) filesize(primaryImage.size!),
        if (primaryImage.width != null && primaryImage.height != null)
          "${primaryImage.width}x${primaryImage.height}",
      ].join(" ");
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          color: Colors.white,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                    " ",
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
                  data: post.content ?? "",
                  onAnchorTap: (url, _, __) {
                    if (url == null) return;

                    if (url.startsWith("#p")) {
                      final postId = int.tryParse(url.substring(2));
                      if (postId != null && onRequestShowPost != null) {
                        onRequestShowPost!(postId);
                      }
                    }
                  },
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(
                          Theme.of(context).textTheme.bodySmall?.fontSize ??
                              14),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    "a": Style(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  })
            ],
          ),
        ))
      ],
    );
  }
}