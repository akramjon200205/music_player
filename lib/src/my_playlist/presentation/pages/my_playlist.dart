import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/src/assets/assets.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';
import 'package:music_player/src/now_playing/presentation/widgets/bottomsheet_mixin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_container_widget.dart';

class MyPlayList extends StatefulWidget {
  const MyPlayList({super.key});

  @override
  State<MyPlayList> createState() => _MyPlayListState();
}

class _MyPlayListState extends State<MyPlayList> with TickerProviderStateMixin, Bottomsheets {
  Duration duration = Duration.zero;
  late AnimationController controller;
  AudioPlayer audioPlayer = AudioPlayer();
  int? itemIndex;

  @override
  void initState() {
    super.initState();
    requestStorage();
    sharedPreferencesFunc();
    context.read<MusicPlaylistCubit>().setAudioPlayer(audioPlayer);
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  requestStorage() async {
    await Permission.storage.request();
  }

  sharedPreferencesFunc() async {
    context.read<MusicPlaylistCubit>().preferences = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextMusic = context.read<MusicPlaylistCubit>();
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
          child: Stack(
            children: [
              BlocBuilder<MusicPlaylistCubit, MusicPlaylistState>(
                builder: (context, state) {
                  if (state is MusicPlaylistInitial) {
                    
                    contextMusic.downloadMusics();
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
                          padding: EdgeInsets.symmetric(horizontal: 18.w).copyWith(top: 70.h, bottom: 120.h),
                          itemCount: state.musicList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                if ((contextMusic.preferences?.getInt("counter") ?? state.index) != index) {
                                  contextMusic.preferences?.setInt("counter", index);
                                  // log("${context.read<MusicPlaylistCubit>().preferences?.getInt("counter")}");
                                  contextMusic.onTapMusicItem(
                                    music: state.musicList[contextMusic.preferences?.getInt("counter") ?? index],
                                    index: contextMusic.preferences?.getInt("counter") ?? index,
                                  );
                                } else if ((contextMusic.preferences?.getInt("counter") ?? state.index) == index) {
                                  playerBottomSheet(context, controller);
                                }
                              },
                              child: CustomContainerWidget(
                                musicModel: state.musicList[index],
                                isActive: (contextMusic.preferences?.getInt("counter") ?? state.index) == index,
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
                      musicModel: state.musicModel ??
                          state.musicList[contextMusic.preferences?.getInt("counter") ?? state.index],
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
