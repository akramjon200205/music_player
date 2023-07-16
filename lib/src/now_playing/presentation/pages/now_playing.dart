import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';
import 'package:music_player/src/now_playing/presentation/widgets/carousel_widget.dart';
import 'package:music_player/src/now_playing/presentation/widgets/favorite_widget.dart';
import 'package:music_player/src/now_playing/presentation/widgets/next_back_pause.dart';

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
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    final contextRead = context.read<MusicPlaylistCubit>();
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.images.musicImageBackground,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
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
                      onTap: () => Navigator.pop(context),
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
                                        .musicList[contextRead.preferences?.getInt("counter") ?? contextRead.indexMusic]
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
                        CustomSlider(
                          activeTrackColor: Colors.white,
                          thumbColor: Colors.white,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        NextBackPauseWidget(contextRead: contextRead),
                        SizedBox(
                          height: 20.h,
                        ),
                        const FavoriteAndVolumeWidget(),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
