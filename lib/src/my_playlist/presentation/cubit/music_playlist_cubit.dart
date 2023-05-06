import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/now_playing/presentation/pages/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../core/db/local_database.dart';
import '../../../core/model/music_model.dart';
import 'music_playlist_state.dart';

class MusicPlaylistCubit extends Cubit<MusicPlaylistState> {
  // int index = 0;

  late List musicModel = [];
  bool onTapPauseGlobal = true;
  int indexMusic = 0;
  OnAudioQuery _audioQuery = OnAudioQuery();
  MusicPlaylistCubit() : super(MusicPlaylistInitial());

  void downloadMusics() async {
    emit(MusicPlaylistLoading());
    musicModel = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,            
    );
    musicModel = musicModels;

    // await Future.delayed(
    //   const Duration(milliseconds: 1500),
    // );
    emit(
      MusicPlaylistLaded(
        musicList: musicModel,
      ),
    );
  }

  void onTapMusicItem({required MusicModel music, required int index}) {
    indexMusic = index;
    emit(
      MusicPlaylistLaded(
        musicList: musicModel,
        musicModel: music,
        index: index,
      ),
    );
  }

  void onTapPause() {
    // if (onTap == true) {
    //   emit(
    //     MusicPlaylistLaded(
    //       musicList: musicModel,
    //       musicModel: musicModel[index],
    //       index: index,
    //       onTap: false,
    //     ),
    //   );
    // } else {
    //   emit(
    //     MusicPlaylistLaded(musicList: musicModel, musicModel: musicModel[index], index: index, onTap: true),
    //   );
    // }
  }

  void onTapLeftBack({
    required MusicModel selectMusic,
    required int selectionIndex,
  }) {
    if (selectionIndex > 0 && selectionIndex < musicModel.length) {
      selectionIndex -= 1;
      emit(
        MusicPlaylistLaded(
          musicList: musicModel,
          musicModel: musicModel[selectionIndex],
          index: selectionIndex,
        ),
      );
    }
  }

  void onTapNext({required MusicModel selectMusic, required int selectionIndex}) {
    if (selectionIndex >= 0 && selectionIndex < musicModel.length - 1) {
      selectionIndex += 1;
      emit(
        MusicPlaylistLaded(
          musicList: musicModel,
          musicModel: musicModel[selectionIndex],
          index: selectionIndex,
        ),
      );
    }
  }
}
