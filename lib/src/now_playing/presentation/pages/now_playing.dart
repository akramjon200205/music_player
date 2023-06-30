import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/repeat_icon.dart';
import 'package:music_player/src/now_playing/presentation/widgets/carousel_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../assets/app_colors.dart';
import '../../../assets/app_text_styles.dart';
import '../../../assets/assets.dart';
import '../../../my_playlist/presentation/widgets/custom_on_tap_icon_widget.dart';
import '../../../my_playlist/presentation/widgets/custom_slider.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    Key? key,
  }) : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  bool isFav = false;

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
    final contextRead = context.read<MusicPlaylistCubit>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Assets.images.musicImageBackground,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 15.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 30.w,
                          width: 30.w,
                          child: Transform.rotate(
                            angle: 3 * pi / 2,
                            child: SvgPicture.asset(
                              Assets.icons.backLeft,
                              height: 28.w,
                              width: 28.w,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Now Playing',
                        style: AppTextStyles.body18w4,
                      ),
                      CustomOnTapIconWidget(
                        function: () {},
                        textAssetsIcon: Assets.icons.menu,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                BlocBuilder<MusicPlaylistCubit, MusicPlaylistState>(
                  builder: (context, state) {
                    if (state is MusicPlaylistLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is MusicPlaylistLoaded) {
                      return Column(
                        children: [
                          const CarouselWidget(),
                          SizedBox(
                            height: 70.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 18.w),
                                height: 30.h,
                                child: Text(
                                  contextRead
                                      .musicList[contextRead.preferences?.getInt("counter") ?? contextRead.indexMusic]
                                      .title,
                                  style: AppTextStyles.body24w4,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 250.w,
                                height: 30.h,
                                child: Text(
                                  contextRead
                                          .musicList[
                                              contextRead.preferences?.getInt("counter") ?? contextRead.indexMusic]
                                          .artist ??
                                      "unknown",
                                  style: AppTextStyles.body18w4,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            child: Column(
                              children: [
                                CustomSlider(
                                  activeTrackColor: Colors.white,
                                  thumbColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomOnTapIconWidget(
                                  function: () {
                                    context.read<MusicPlaylistCubit>().randomMusicPlay();
                                  },
                                  textAssetsIcon: Assets.icons.randomMusic,
                                ),
                                Row(
                                  children: [
                                    CustomOnTapIconWidget(
                                      function: () {
                                        contextRead.onTapLeftBackNowPlaying();
                                      },
                                      textAssetsIcon: Assets.icons.prevLeft,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 35.w,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          contextRead.onTapPause();
                                        },
                                        child: Container(
                                          height: 60.h,
                                          width: 60.h,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            gradient: AppColors.nowPlayingContainerGradient,
                                            shape: BoxShape.circle,
                                          ),
                                          child: context.watch<MusicPlaylistCubit>().isPlaying
                                              ? SvgPicture.asset(Assets.icons.pause)
                                              : SvgPicture.asset(Assets.icons.playMusic),
                                        ),
                                      ),
                                    ),
                                    CustomOnTapIconWidget(
                                      function: () {
                                        contextRead.onTapNextNowPlaying();
                                      },
                                      textAssetsIcon: Assets.icons.nextRight,
                                    ),
                                  ],
                                ),
                                const RepeatIcon(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
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
                                            developer.log(contextRead.favoriteMusic.length.toString());
                                          } else {
                                            contextRead.favoriteMusic
                                                .removeWhere((element) => element == contextRead.indexMusic);
                                            developer.log(contextRead.favoriteMusic.length.toString());
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
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
