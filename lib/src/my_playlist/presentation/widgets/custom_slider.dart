import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';

import '../../../assets/app_text_styles.dart';
import '../../../now_playing/presentation/widgets/duration_music.dart';

// ignore: must_be_immutable
class CustomSlider extends StatefulWidget {
  Color activeTrackColor;
  Color thumbColor;
  CustomSlider({
    Key? key,
    required this.activeTrackColor,
    required this.thumbColor,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late final AudioPlayer audioPlayer;
  double sliderPosition = 0;
  int seconds = 0;
  @override
  void initState() {
    audioPlayer = context.read<MusicPlaylistCubit>().audioPlayer;

    audioPlayer.positionStream.listen((event) {
      setState(() {
        sliderPosition = event.inSeconds / (audioPlayer.duration == null ? 1 : audioPlayer.duration!.inSeconds) * 100;
        seconds = event.inMilliseconds.toInt();
      });
      if (sliderPosition == 100) {
        switch (context.read<MusicPlaylistCubit>().onTaprepeat) {
          case true:
            break;
          case false:
            {
              Future.delayed(
                const Duration(milliseconds: 800),
              ).then(
                (value) => context.read<MusicPlaylistCubit>().caruselSliderNext(),
              );
              context.read<MusicPlaylistCubit>().onTapNext();
              break;
            }
        }
      }
    });

    super.initState();
  }

  String positionMusic() {
    int durationInSeconds = seconds ~/ 1000;
    int minutes = durationInSeconds ~/ 60;
    int second = durationInSeconds % 60;
    if (second ~/ 10 < 1) {
      return '$minutes : 0$second';
    }
    return '$minutes : $second';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 6.w,
          width: double.infinity,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: widget.activeTrackColor,
              inactiveTrackColor: Colors.white.withOpacity(0.5),
              activeTickMarkColor: Colors.white.withOpacity(0.5),
              trackShape: const RectangularSliderTrackShape(),
              trackHeight: 4,
              thumbColor: widget.thumbColor,
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
                  context.read<MusicPlaylistCubit>().onSeekMusic(
                        Duration(
                          milliseconds: audioPlayer.duration!.inMilliseconds * value ~/ 100,
                        ),
                      );
                },
                onChanged: (double value) {},
              ),
            ),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              positionMusic(),
              style: AppTextStyles.body14w4,
            ),
            Text(
              formatTime(
                context.read<MusicPlaylistCubit>().musicList[
                    context.read<MusicPlaylistCubit>().preferences?.getInt("counter") ??
                        context.read<MusicPlaylistCubit>().indexMusic],
              ),
              style: AppTextStyles.body14w4,
            ),
          ],
        ),
      ],
    );
  }
}
