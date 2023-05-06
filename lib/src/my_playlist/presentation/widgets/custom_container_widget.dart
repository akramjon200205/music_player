// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

import 'package:music_player/src/core/model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../assets/app_text_styles.dart';
import '../../../assets/assets.dart';
import '../../../now_playing/presentation/widgets/duration_music.dart';

// ignore: must_be_immutable
class CustomContainerWidget extends StatelessWidget {
  bool onTap;
  bool onTapPause;
  SongModel musicModel;

  CustomContainerWidget({
    Key? key,
    required this.onTap,
    required this.onTapPause,
    required this.musicModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool boolean() {
      return onTap;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 80.h,
          padding: EdgeInsets.only(left: 10.w, right: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: onTap ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60.h,
                    width: 60.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 50.w,
                          width: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: const Color(0xff1A1335).withOpacity(0.5),
                          ),
                          child: QueryArtworkWidget(
                            id: musicModel.id,
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(10.r),
                            artworkFit: BoxFit.fill,
                            // imageSized: 28.h,
                          ),
                          // Image.asset(
                          //   musicModel.image ?? Assets.icons.musicNote,
                          // ),
                        ),
                        // boolean()
                        //     ? PlayAndPauseWidget(
                        //         onTap: onTapPause,
                        //       )
                        //     : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          musicModel.title ?? "unknown",
                          style: AppTextStyles.body16w4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          musicModel.artist ?? "unknown",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body16w4.copyWith(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 40.w,
                alignment: Alignment.center,
                child: boolean()
                    ? SvgPicture.asset(Assets.icons.soundWave)
                    : Text(
                        formatTime(musicModel),
                        style: AppTextStyles.body16w4,
                      ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class PlayAndPauseWidget extends StatelessWidget {
  bool onTap;
  PlayAndPauseWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 28.w,
        width: 28.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white.withOpacity(.3),
        ),
        child: SvgPicture.asset(
          onTap ? Assets.icons.playMusic : Assets.icons.pause,
          height: 10.w,
          width: 12.w,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
