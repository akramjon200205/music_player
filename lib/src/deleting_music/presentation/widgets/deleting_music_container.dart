// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/assets/app_text_styles.dart';
import 'package:music_player/src/assets/assets.dart';
import 'package:music_player/src/now_playing/presentation/widgets/duration_music.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class DeletingMusicContainer extends StatelessWidget {
  bool isActive;
  SongModel musicModel;
  final Widget image = SvgPicture.asset(
    Assets.icons.musicNote,
    height: 50,
    fit: BoxFit.scaleDown,
  );

  DeletingMusicContainer({
    Key? key,
    required this.isActive,
    required this.musicModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 80.w,
          padding: EdgeInsets.only(left: 10.w, right: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: isActive ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: Text(
                          musicModel.title,
                          style: AppTextStyles.body16w4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      SizedBox(
                        width: 180.w,
                        child: Text(
                          musicModel.artist ?? "unknown",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
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
                child: Text(
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
