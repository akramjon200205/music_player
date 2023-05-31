import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/src/assets/app_colors.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    final contextRead = context.read<MusicPlaylistCubit>();
    return CarouselSlider.builder(
      itemCount: contextRead.musicList.length,
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
            color: AppColors.white.withOpacity(0.15),
          ),
          child: QueryArtworkWidget(
            id: contextRead.musicList[index].id,
            type: ArtworkType.AUDIO,
            artworkBorder: BorderRadius.circular(40.r),
            artworkFit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
