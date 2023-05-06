// import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:music_player/src/assets/app_colors.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/db/local_database.dart';
import '../../../now_playing/presentation/pages/now_playing.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_container_widget.dart';

class MyPlayList extends StatefulWidget {
  const MyPlayList({super.key});

  @override
  State<MyPlayList> createState() => _MyPlayListState();
}

class _MyPlayListState extends State<MyPlayList> with TickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool onTap = true;
  bool isPlaying = false;
  bool onTapPause = true;
  // final music = "serena_safari_remix.mp3";
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    Permission.storage.request();
    controller = AnimationController(vsync: this);
    controller.duration = const Duration(milliseconds: 800);    
  }

  // playSong() {
  //   try {
  //     audioPlayer
  //         .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
  //     audioPlayer.play();
  //     playing = true;
  //   } on Exception {
  //     log('Cannot Parse song');
  //   }
  // }

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
                } else if (state is MusicPlaylistLaded) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 18.w).copyWith(top: 70.h, bottom: 120.h),
                        itemCount: state.musicList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              if (state.index != index) {
                                // audioPlayer.play(
                                //   AssetSource("assets/serena_safari_remix.mp3"),
                                // );
                                context.read<MusicPlaylistCubit>().onTapMusicItem(
                                      music: state.musicList[index],
                                      index: index,
                                    );
                              } else if (state.index == index) {
                                showBottomSheet(
                                  transitionAnimationController: controller,
                                  elevation: 0,
                                  context: context,
                                  builder: (context) {
                                    return NowPlaying(
                                      initialValue: index,
                                      musicList: state.musicList,
                                    );
                                  },
                                );
                                // if (state.onTap == true) {

                                // } else {

                                // }
                              }
                            },
                            child: CustomContainerWidget(
                              musicModel: state.musicList[index],
                              onTap: state.index == index,
                              onTapPause: state.isPlay,
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
                if (state is MusicPlaylistLaded) {
                  return CustomAppBar(
                    // onTapPause: state.musicList[state.index] != state.musicModel,
                    onTap: state.isPlay,
                    index: state.index,
                    musicModel: state.musicModel ?? state.musicList[state.index],
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
