import 'package:cabinet/database/image.dart' as database;
import 'package:cabinet/widgets/dynamic_image.dart';
import 'package:cabinet/widgets/modal/media_viewer.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final List<database.Image> images;

  const ImageGrid({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      childAspectRatio: 1 / 1,
      children: images.map((image) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Stack(
            children: [
              Positioned.fill(
                  child: DynamicImage(
                image: image,
                fit: BoxFit.cover,
              )),
              Positioned.fill(
                  child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MediaViewerModal(
                        images: images, currentIndex: images.indexOf(image)));
                  },
                ),
              )),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${image.extension?.toUpperCase().substring(1)} ${image.width}x${image.height} ${filesize(image.size!)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
