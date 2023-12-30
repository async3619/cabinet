import 'dart:io';

import 'package:cabinet/database/image.dart' as db_image;
import 'package:flutter/material.dart';

class DynamicImage extends StatefulWidget {
  const DynamicImage({
    Key? key,
    this.image,
    this.showThumbnail = true,
    this.fit,
  }) : super(key: key);

  final BoxFit? fit;
  final db_image.Image? image;
  final bool showThumbnail;

  @override
  State<DynamicImage> createState() => _DynamicImageState();
}

class _DynamicImageState extends State<DynamicImage> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    final image = widget.image;
    if (image == null) return;

    final targetPath = widget.showThumbnail ? image.thumbnailPath : image.path;
    if (targetPath == null) return;

    _imageFile = File(targetPath);
  }

  @override
  void didUpdateWidget(DynamicImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final image = widget.image;
    if (image == null) return;

    final targetPath = widget.showThumbnail ? image.thumbnailPath : image.path;
    if (targetPath == null) return;

    _imageFile = File(targetPath);
  }

  @override
  build(context) {
    final image = widget.image;
    if (image == null) return Container();

    if (_imageFile != null) {
      return Image.file(_imageFile!, fit: widget.fit);
    }

    final targetUrl = widget.showThumbnail ? image.thumbnailUrl : image.url;
    if (targetUrl == null) return Container();

    return Image.network(targetUrl, fit: widget.fit);
  }
}
