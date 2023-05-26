// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/repeat_icon.dart';
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

class _NowPlayingState extends State<NowPlaying> {
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
                    horizontal: 30.w,
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
                          CarouselSlider.builder(
                            itemCount: context.read<MusicPlaylistCubit>().musicList.length,
                            carouselController: context.read<MusicPlaylistCubit>().carouselController,
                            options: CarouselOptions(
                              aspectRatio: 1.5,
                              reverse: false,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                              initialPage: contextRead.preferences?.getInt("counter") ?? contextRead.indexMusic,
                              autoPlay: false,
                              scrollPhysics: const NeverScrollableScrollPhysics(),
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                height: 280.w,
                                width: 280.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  color: const Color(0xff1A1335).withOpacity(0.5),
                                ),
                                child: QueryArtworkWidget(
                                  id: contextRead.musicList[index].id,
                                  type: ArtworkType.AUDIO,
                                  artworkBorder: BorderRadius.circular(40.r),
                                  artworkFit: BoxFit.fill,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 70.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 250.w,
                                height: 30.h,
                                child: Text(
                                  contextRead
                                      .musicList[contextRead.preferences?.getInt("counter") ?? contextRead.indexMusic]
                                      .title,
                                  style: AppTextStyles.body24w4,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 200.w,
                                height: 30.h,
                                child: Text(
                                  contextRead
                                          .musicList[
                                              contextRead.preferences?.getInt("counter") ?? contextRead.indexMusic]
                                          .artist ??
                                      "unknown",
                                  style: AppTextStyles.body18w4,
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
                                RepeatIcon(
                                  function: () {
                                    context.read<MusicPlaylistCubit>().repeatFunc();
                                  },
                                  onTap: context.watch<MusicPlaylistCubit>().onTaprepeat,
                                ),
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
                                CustomOnTapIconWidget(
                                  function: () {},
                                  textAssetsIcon: Assets.icons.favorite,
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
