import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/custom_on_tap_icon_widget.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/repeat_icon.dart';

import '../../../assets/app_colors.dart';
import '../../../assets/assets.dart';

class NextBackPauseWidget extends StatelessWidget {
  final MusicPlaylistCubit contextRead;

  const NextBackPauseWidget({
    super.key,
    required this.contextRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomOnTapIconWidget(
            function: () {
              contextRead.randomMusicPlay();
            },
            textAssetsIcon: Assets.icons.randomMusic,
          ),
          Row(
            children: [
              CustomOnTapIconWidget(
                function: () {
                  contextRead.onTapLeftBack();
                  contextRead.caruselSliderNext();
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
                  contextRead.onTapNext();
                  contextRead.caruselSliderNext();
                },
                textAssetsIcon: Assets.icons.nextRight,
              ),
            ],
          ),
          const RepeatIcon(),
        ],
      ),
    );
  }
}
