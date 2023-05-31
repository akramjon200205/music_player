import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_state.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/custom_app_bar.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/custom_container_widget.dart';
import 'package:music_player/src/my_playlist/presentation/widgets/scale_widget.dart';
import 'package:music_player/src/now_playing/presentation/pages/now_playing.dart';

import '../../../../assets/assets.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
          child: BlocBuilder<MusicPlaylistCubit, MusicPlaylistState>(
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
                              onTap: () async {
                                if ((contextMusic.preferences?.getInt("counter") ?? state.index) != index) {
                                  contextMusic.preferences?.setInt("counter", index);
                                  contextMusic.onTapMusicItem(
                                    music: state.musicList[contextMusic.preferences?.getInt("counter") ?? index],
                                    index: contextMusic.preferences?.getInt("counter") ?? index,
                                  );
                                } else if ((contextMusic.preferences?.getInt("counter") ?? state.index) == index) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return const NowPlaying();
                                      },
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        final Widget transition = SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.0, 1.0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset.zero,
                                              end: const Offset(0.0, -0.7),
                                            ).animate(secondaryAnimation),
                                            child: child,
                                          ),
                                        );
                                        return transition;
                                      },
                                      transitionDuration: const Duration(milliseconds: 500),
                                    ),
                                  );
                                }
                              },
                              child: CustomContainerWidget(
                                musicModel: state.musicList[index],
                                isActive: (contextMusic.preferences?.getInt("counter") ?? state.index) == index,
                              ),
                              time: 50,
                              isWait: true,
                            );
                          },                          
                        ),
                      ),
                    ),
                    CustomAppBar(
                      musicModel: state.musicModel ??
                          state.musicList[contextMusic.preferences?.getInt("counter") ?? state.index],
                    ),
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
