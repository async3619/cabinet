import 'package:cabinet/widgets/media_viewer.dart';
import 'package:flutter/material.dart';
import 'package:cabinet/database/image.dart' as database;
import 'package:video_player/video_player.dart';

class MediaViewerModal extends ModalRoute {
  final List<database.Image> images;
  late final PageController pageController;
  late VideoPlayerController? videoPlayerController;
  late bool isVideoInitialized = false;

  int currentIndex = 0;

  MediaViewerModal({
    required this.images,
    this.currentIndex = 0,
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

  handlePageChanged(int index) {
    setState(() {
      currentIndex = index;
    });

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
