// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:music_player/src/core/model/music_model.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';

import '../../../assets/app_colors.dart';
import '../../../assets/app_text_styles.dart';
import '../../../assets/assets.dart';
import '../../../my_playlist/presentation/widgets/custom_on_tap_icon_widget.dart';

// ignore: must_be_immutable
class NowPlaying extends StatefulWidget {
  List<MusicModel> musicList;
  int initialValue;
  // bool onTap;
  // bool onTapPause;

  NowPlaying({
    Key? key,
    required this.musicList,
    required this.initialValue,
    // required this.onTap,
    // required this.onTapPause,
  }) : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final CarouselController _carouselController = CarouselController();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.nowPlayingListBackgroundColor,
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
                    if (state is MusicPlaylistLaded) {
                      return Column(
                        children: [
                          CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              aspectRatio: 1.5,
                              onPageChanged: (value, reason) {
                                widget.initialValue = value;
                              },
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                              initialPage: widget.initialValue,
                              autoPlay: false,
                              scrollPhysics: const BouncingScrollPhysics(),
                            ),
                            items: List.generate(
                              widget.musicList.length,
                              (index) {
                                return Container(
                                  height: 280.w,
                                  width: 280.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.r),
                                    color: const Color(0xff1A1335).withOpacity(0.5),
                                  ),
                                  child: Image.asset(
                                    widget.musicList[index].image!,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
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
                                  widget.musicList[widget.initialValue].musicName ?? "unknown",
                                  style: AppTextStyles.body24w4,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 200.w,
                                height: 30.h,
                                child: Text(
                                  widget.musicList[widget.initialValue].songWriterName ?? "unknown",
                                  style: AppTextStyles.body18w4,
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                            ],
                          ),
                          BlocBuilder<MusicPlaylistCubit, MusicPlaylistState>(
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.white.withOpacity(0.5),
                                        activeTickMarkColor: Colors.white.withOpacity(0.5),
                                        trackShape: const RectangularSliderTrackShape(),
                                        trackHeight: 4,
                                        thumbColor: Colors.white,
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                                      ),
                                      child: SizedBox(
                                        child: Slider(
                                          min: 0,
                                          max: duration.inSeconds.toDouble(),
                                          value: position.inSeconds.toDouble(),
                                          onChanged: (value) {
                                            // final position = Duration(seconds: value.toInt());
                                          },
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
                                          widget.musicList[widget.initialValue].time ?? '00:00',
                                          style: AppTextStyles.body14w4,
                                        ),
                                        Text(
                                          widget.musicList[widget.initialValue].time ?? "00:00",
                                          style: AppTextStyles.body14w4,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
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
                                  function: () {},
                                  textAssetsIcon: Assets.icons.randomMusic,
                                ),
                                Row(
                                  children: [
                                    CustomOnTapIconWidget(
                                      function: () {
                                        if (widget.initialValue > 0) {
                                          widget.initialValue = widget.initialValue - 1;
                                          _carouselController.animateToPage(
                                            widget.initialValue + 1,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      textAssetsIcon: Assets.icons.prevLeft,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 35.w,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // widget.onTapPause != widget.onTapPause;
                                        },
                                        child: Container(
                                          height: 60.h,
                                          width: 60.h,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            gradient: AppColors.nowPlayingContainerGradient,
                                            shape: BoxShape.circle,
                                          ),
                                          child: context.read<MusicPlaylistCubit>().onTapPauseGlobal
                                              ? SvgPicture.asset(Assets.icons.playMusic)
                                              : SvgPicture.asset(Assets.icons.pause),
                                        ),
                                      ),
                                    ),
                                    CustomOnTapIconWidget(
                                      function: () {
                                        if (widget.initialValue < widget.musicList.length) {
                                          widget.initialValue = widget.initialValue + 1;
                                          _carouselController.animateToPage(
                                            widget.initialValue + 1,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      textAssetsIcon: Assets.icons.nextRight,
                                    ),
                                  ],
                                ),
                                CustomOnTapIconWidget(
                                  function: () {},
                                  textAssetsIcon: Assets.icons.reshare,
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
                                  function: () {},
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
