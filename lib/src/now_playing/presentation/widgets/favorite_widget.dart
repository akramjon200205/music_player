import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/src/assets/assets.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/custom_on_tap_icon_widget.dart';

import '../../../assets/app_colors.dart';

class FavoriteAndVolumeWidget extends StatefulWidget {
  const FavoriteAndVolumeWidget({
    super.key,
  });

  @override
  State<FavoriteAndVolumeWidget> createState() => _FavoriteAndVolumeWidgetState();
}

class _FavoriteAndVolumeWidgetState extends State<FavoriteAndVolumeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (context.read<MusicPlaylistCubit>().favoriteMusic.contains(context.read<MusicPlaylistCubit>().indexMusic)) {
      _colorAnimation = ColorTween(begin: AppColors.favoriteColor, end: Colors.white).animate(_controller);
    } else {
      _colorAnimation = ColorTween(begin: Colors.white, end: AppColors.favoriteColor).animate(_controller);
    }

    _animation = (TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween(begin: 28, end: 35),
        weight: 28,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 35, end: 28),
        weight: 28,
      ),
    ]).animate(_controller));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var contextRead = context.read<MusicPlaylistCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomOnTapIconWidget(
            function: () {
              context.read<MusicPlaylistCubit>().audioPlayer.volumeStream.listen((event) {});
            },
            textAssetsIcon: Assets.icons.valume,
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Container(
                alignment: Alignment.center,
                child: IconButton(
                  alignment: Alignment.center,
                  onPressed: () {
                    if (_colorAnimation.value == Colors.white) {
                      contextRead.favoriteMusic.add(contextRead.indexMusic);
                    } else {
                      contextRead.favoriteMusic.removeWhere((element) => element == contextRead.indexMusic);
                    }
                    if (_controller.isCompleted) {
                      _controller.reverse();
                    } else {
                      _controller.forward();
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    size: _animation.value,
                    color: _colorAnimation.value,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
