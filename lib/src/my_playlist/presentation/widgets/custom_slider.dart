import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late final AudioPlayer audioPlayer;
  double sliderPosition = 0;
  @override
  void initState() {
    audioPlayer = context.read<MusicPlaylistCubit>().audioPlayer;

    audioPlayer.positionStream.listen((event) {
      setState(() {
        sliderPosition = event.inSeconds / (audioPlayer.duration == null ? 1 : audioPlayer.duration!.inSeconds) * 100;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.w,
      width: double.infinity,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: const Color(0xff191234),
          inactiveTrackColor: Colors.white.withOpacity(0.5),
          activeTickMarkColor: Colors.white.withOpacity(0.5),
          trackShape: const RectangularSliderTrackShape(),
          trackHeight: 4,
          thumbColor: const Color(0xff191234),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Slider(
            min: 0,
            max: 100,
            divisions: 100,
            value: sliderPosition,
            onChangeEnd: (value) {
              context
                  .read<MusicPlaylistCubit>()
                  .onSeekMusic(Duration(milliseconds: (audioPlayer.duration!.inMilliseconds * value / 100).toInt()));
            },
            onChanged: (double value) {},
          ),
        ),
      ),
    );
  }
}
