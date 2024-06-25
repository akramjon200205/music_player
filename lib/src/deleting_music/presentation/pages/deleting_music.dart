import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/src/assets/app_text_styles.dart';
import 'package:music_player/src/assets/assets.dart';
import 'package:music_player/src/deleting_music/presentation/cubit/deleting_cubit.dart';
import 'package:music_player/src/deleting_music/presentation/widgets/deleting_music_container.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/scale_widget.dart';

class DeletingMusic extends StatefulWidget {
  const DeletingMusic({super.key});

  @override
  State<DeletingMusic> createState() => _DeletingMusicState();
}

class _DeletingMusicState extends State<DeletingMusic> {
  @override
  void initState() {
    super.initState();

    context.read<DeletingMusicCubit>().deletingMusiclist = context.read<MusicPlaylistCubit>().musicList;
  }

  @override
  Widget build(BuildContext context) {
    var contextRead = context.read<DeletingMusicCubit>();
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.images.musicImageBackground,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: BlocBuilder<DeletingMusicCubit, DeletingMusicState>(
            builder: (context, state) {
              if (state is DeletingMusicInitial) {
                contextRead.deletingMusics();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is DeletingMusicLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MusicPlaylistError) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is DeletingMusicLoaded) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 18.w).copyWith(top: 70.h, bottom: 120.h),
                          itemCount: state.musicList.length,
                          itemBuilder: (context, index) {
                            return scaleWidget(
                              onLongPress: () {},
                              onTap: () async {},
                              child: DeletingMusicContainer(
                                musicModel: state.musicList[index],
                                isActive: state.index == index,
                              ),
                              time: 50,
                              isWait: true,
                            );
                          },
                        ),
                      ),
                    ),
                    const DeletingMusicAppBarWidget(),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    "Error data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class DeletingMusicAppBarWidget extends StatelessWidget {
  const DeletingMusicAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 15.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              height: 30.w,
              width: 30.w,
              child: SvgPicture.asset(
                Assets.icons.backLeft,
                height: 28.w,
                width: 28.w,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Text(
            "Deleting Music",
            style: AppTextStyles.body18w4,
          ),
          SizedBox(
            width: 30.w,
          ),
        ],
      ),
    );
  }
}
