// import 'package:audioplayers/audioplayers.dart';

// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/src/assets/app_colors.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';
import 'package:music_player/src/now_playing/presentation/widgets/bottomsheet_mixin.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_container_widget.dart';

class MyPlayList extends StatefulWidget {
  const MyPlayList({super.key});

  @override
  State<MyPlayList> createState() => _MyPlayListState();
}

class _MyPlayListState extends State<MyPlayList>
    with TickerProviderStateMixin, Bottomsheets {
  Duration duration = Duration.zero;
  late AnimationController controller;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    Permission.storage.request();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    context.read<MusicPlaylistCubit>().setAudioPlayer(audioPlayer);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.myPlayListBackgroundColor,
              ),
            ),
            BlocBuilder<MusicPlaylistCubit, MusicPlaylistState>(
              builder: (context, state) {
                if (state is MusicPlaylistInitial) {
                  context.read<MusicPlaylistCubit>().downloadMusics();
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is MusicPlaylistLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MusicPlaylistError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is MusicPlaylistLoaded) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 18.w)
                            .copyWith(top: 70.h, bottom: 120.h),
                        itemCount: state.musicList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              if (state.index != index) {
                                context
                                    .read<MusicPlaylistCubit>()
                                    .onTapMusicItem(
                                      music: state.musicList[index],
                                      index: index,
                                    );
                              } else if (state.index == index) {
                                playerBottomSheet(context, controller);
                              }
                            },
                            child: CustomContainerWidget(
                              musicModel: state.musicList[index],
                              isActive: state.index == index,
                            ),
                          );
                        },
                      ),
                    ),
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
            BlocBuilder<MusicPlaylistCubit, MusicPlaylistState>(
              builder: (context, state) {
                if (state is MusicPlaylistLoaded) {
                  return CustomAppBar(
                    index: state.index,
                    musicModel:
                        state.musicModel ?? state.musicList[state.index],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
