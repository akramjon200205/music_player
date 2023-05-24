// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:music_player/src/my_playlist/presentation/widgets/repeat_icon.dart';
import 'package:music_player/src/now_playing/presentation/widgets/bottomsheet_mixin.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../assets/app_colors.dart';
import '../../../assets/app_text_styles.dart';
import '../../../assets/assets.dart';
import '../cubit/music_playlist_cubit.dart';
import '../cubit/music_playlist_state.dart';
import 'custom_on_tap_icon_widget.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatefulWidget {
  SongModel musicModel;

  CustomAppBar({
    Key? key,
    required this.musicModel,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with TickerProviderStateMixin, Bottomsheets {
  late AnimationController controller;
  double valueSlider = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    controller.duration = const Duration(milliseconds: 800);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 55.h,
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            left: 18.w,
            right: 18.w,
          ),
          decoration: BoxDecoration(gradient: AppColors.myPlayListContainerColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomOnTapIconWidget(
                function: () {},
                textAssetsIcon: Assets.icons.backLeft,
              ),
              Text(
                'My Playlist',
                style: AppTextStyles.body18w4,
              ),
              CustomOnTapIconWidget(
                function: () {},
                textAssetsIcon: Assets.icons.menu,
              ),
            ],
          ),
        ),
        BlocBuilder<MusicPlaylistCubit, MusicPlaylistState>(
          builder: (context, state) {
            if (state is MusicPlaylistLoading) {
              return const SizedBox.shrink();
            } else if (state is MusicPlaylistLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CustomSlider(
                  //   activeTrackColor: const Color(0xff191234),
                  //   thumbColor: const Color(0xff191234),
                  // ),
                  GestureDetector(
                    onTap: () {
                      playerBottomSheet(context, controller);
                    },
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          height: 98.h,
                          padding: EdgeInsets.symmetric(horizontal: 28.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomOnTapIconWidget(
                                function: () {
                                  context.read<MusicPlaylistCubit>().onTapLeftBack();
                                },
                                textAssetsIcon: Assets.icons.prevLeft,
                              ),
                              RepeatIcon(
                                function: () {
                                  context.read<MusicPlaylistCubit>().repeatFunc();
                                },
                                onTap: context.read<MusicPlaylistCubit>().onTaprepeat,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SongWidget(text: widget.musicModel.title),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  SongWidget(text: widget.musicModel.artist),
                                ],
                              ),
                              CustomOnTapIconWidget(
                                function: () {
                                  context.read<MusicPlaylistCubit>().onTapPause();
                                },
                                textAssetsIcon: context.watch<MusicPlaylistCubit>().isPlaying
                                    ? Assets.icons.pause
                                    : Assets.icons.playMusic,
                              ),
                              CustomOnTapIconWidget(
                                function: () {
                                  context.read<MusicPlaylistCubit>().onTapNext();
                                },
                                textAssetsIcon: Assets.icons.nextRight,
                              ),
                            ],
                          ),
                        ),
                      ),
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
    );
  }
}

class SongWidget extends StatelessWidget {
  final String? text;

  const SongWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      alignment: Alignment.center,
      child: Text(
        text ?? "unknown",
        style: AppTextStyles.body13w4,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
