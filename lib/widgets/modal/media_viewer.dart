import 'package:cabinet/database/image.dart' as database;
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/system/file.dart';
import 'package:cabinet/widgets/media_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MediaViewerModal extends ModalRoute {
  final List<database.Image> images;
  late final PageController pageController;
  late VideoPlayerController? videoPlayerController;
  late bool isVideoInitialized = false;
  late final Function(int)? onIndexChanged;

  int currentIndex = 0;

  MediaViewerModal({
    required this.images,
    this.currentIndex = 0,
    this.onIndexChanged,
  }) : super() {
    pageController = PageController(initialPage: currentIndex);
  }

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

  handleSavePressed(BuildContext context) async {
    await FileSystem().saveImageToGallery(images[currentIndex]);

    Fluttertoast.showToast(
        msg: 'Image saved to gallery',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  handleFavoriteClick(BuildContext context) {
    final image = images[currentIndex];
    image.isFavorite = image.isFavorite != true ? true : false;

    final repositoryHolder =
        Provider.of<RepositoryHolder>(context, listen: false);

    repositoryHolder.image.save(image);

    changedExternalState();
  }

  handlePageChanged(int index) {
    setState(() {
      currentIndex = index;
    });

    if (onIndexChanged != null) {
      onIndexChanged!(index);
    }

    changedExternalState();
  }

  Widget buildViewer(BuildContext context, database.Image image, int index) {
    final isActive = index == currentIndex;

    return MediaViewer(
      image: image,
      isActive: isActive,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final currentImage = images[currentIndex];

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
                Text(
                  '${currentImage.filename}${currentImage.extension}',
                ),
                Text(
                  '${currentIndex + 1} / ${images.length}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  currentImage.isFavorite == true
                      ? Icons.star
                      : Icons.star_border,
                ),
                onPressed: () => handleFavoriteClick(context),
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => handleSavePressed(context),
              ),
            ],
          ),
          Expanded(
              child: PageView(
                  controller: pageController,
                  onPageChanged: handlePageChanged,
                  children: [
                for (var index = 0; index < images.length; index++)
                  buildViewer(context, images[index], index)
              ])),
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
