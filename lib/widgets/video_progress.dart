import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const CustomSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx +
        sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width -
        sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width *
            2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class VideoProgress extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoProgress({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<VideoProgress> createState() => _VideoProgressState();
}

class _VideoProgressState extends State<VideoProgress> {
  bool isDragging = false;
  double value = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(handleControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(handleControllerChanged);
    super.dispose();
  }

  handleControllerChanged() {
    if (isDragging) {
      return;
    }

    setState(() {});
  }

  handleChangeStart(double value) {
    widget.controller.pause();
  }

  handleChange(double value) {
    setState(() {
      this.value = value;
    });

    widget.controller.seekTo(Duration(milliseconds: value.toInt()));
  }

  handleChangeEnd(double value) {
    widget.controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final currentTimeText =
        '${widget.controller.value.position.inMinutes}:${widget.controller.value.position.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    final durationText =
        '${widget.controller.value.duration.inMinutes}:${widget.controller.value.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    final max = widget.controller.value.duration.inMilliseconds.toDouble();
    final value = clampDouble(
        widget.controller.value.position.inMilliseconds.toDouble(), 0, max);

    return Row(
      children: [
        Text(currentTimeText),
        Expanded(
            child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: CustomSliderTrackShape(),
          ),
          child: Container(
              height: 20,
              child: Slider(
                inactiveColor: Colors.grey,
                activeColor: Colors.white,
                min: 0,
                max: max,
                value: value,
                onChangeStart: handleChangeStart,
                onChanged: handleChange,
                onChangeEnd: handleChangeEnd,
              )),
        )),
        Text(durationText),
      ],
    );
  }
}
