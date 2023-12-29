import 'package:cabinet/widgets/dynamic_image.dart';
import 'package:cabinet/widgets/modal/media_viewer.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:cabinet/database/image.dart' as database;

class AlbumModal extends ModalRoute {
  final List<database.Image> images;
  final String title;

  AlbumModal({
    required this.images,
    required this.title,
  }) : super();

  @override
  Color get barrierColor => Colors.black.withOpacity(0.75);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(
                  '${images.length} images',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
              child: GridView.count(
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
                              images: images,
                              currentIndex: images.indexOf(image)));
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
          ))
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(animation),
        // add scale animation
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 1,
            end: 1,
          ).animate(animation),
          child: child,
        ),
      ),
    );
  }
}
