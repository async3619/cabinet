import 'dart:io';

import 'package:cabinet/database/image.dart' as database;
import 'package:cabinet/widgets/dynamic_image.dart';
import 'package:cabinet/widgets/video_progress.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaViewer extends StatefulWidget {
  const MediaViewer({
    Key? key,
    required this.image,
    required this.isActive,
  }) : super(key: key);

  final database.Image image;
  final bool isActive;

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool isVideoInitialized = false;
  bool isVideoPlaying = true;
  bool showControls = false;

  @override
  void didUpdateWidget(MediaViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleInitialize();
  }

  @override
  void initState() {
    super.initState();
    handleInitialize();
  }

  @override
  void dispose() {
    handleFinalize();
    super.dispose();
  }

  handleInitialize() {
    if (!widget.image.isVideo) {
      return;
    }

    if (!widget.isActive) {
      if (_controller != null && _chewieController != null) {
        setState(() {
          handleFinalize();
          _controller = null;
          _chewieController = null;
        });
      }

      return;
    }

    if (widget.image.path == null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.image.url!));
    } else {
      _controller = VideoPlayerController.file(File(widget.image.path!));
    }

    if (_controller == null) {
      return;
    }

    _controller!.addListener(() {
      if (_controller!.value.isPlaying != isVideoPlaying) {
        setState(() {
          isVideoPlaying = _controller!.value.isPlaying;
        });
      }
    });

    _controller!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: true,
        autoInitialize: true,
        allowFullScreen: false,
        showControls: false,
        showControlsOnInitialize: false,
      );

      setState(() {
        isVideoInitialized = true;
      });
    });
  }

  handleFinalize() {
    if (widget.image.isVideo &&
        _controller != null &&
        _chewieController != null) {
      _controller!.dispose();
      _chewieController!.dispose();
    }
  }

  handlePlayPause() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  Widget buildImage() {
    return DynamicImage(
      image: widget.image,
      fit: BoxFit.cover,
    );
  }

  Widget buildVideo() {
    if (!isVideoInitialized ||
        _chewieController == null ||
        _controller == null) {
      return DynamicImage(
        image: widget.image,
        showThumbnail: true,
        fit: BoxFit.cover,
      );
    }

    return Chewie(
      controller: _chewieController!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.image;
    Widget child;
    if (widget.image.isImage) {
      child = buildImage();
    } else {
      child = buildVideo();
    }

    return Stack(
      children: [
        Positioned.fill(
            child: Row(
          children: [
            Expanded(
                child: AspectRatio(
              aspectRatio: image.width! / image.height!,
              child: child,
            ))
          ],
        )),
        Positioned.fill(child: GestureDetector(
          onTap: () {
            setState(() {
              showControls = !showControls;
            });
          },
        )),
        if (widget.isActive && image.isVideo && showControls)
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(0.75),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Material(
                            color: Colors.transparent,
                            child: IconButton(
                                splashRadius: 24,
                                iconSize: 32,
                                onPressed: handlePlayPause,
                                icon: Icon(isVideoPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow))),
                        const SizedBox(height: 8),
                        VideoProgress(
                          controller: _controller!,
                        ),
                      ],
                    )),
              )),
      ],
    );
  }
}
