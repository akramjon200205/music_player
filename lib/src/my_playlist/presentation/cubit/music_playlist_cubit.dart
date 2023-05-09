import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/src/now_playing/presentation/pages/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../core/db/local_database.dart';
import '../../../core/model/music_model.dart';
import 'music_playlist_state.dart';

class MusicPlaylistCubit extends Cubit<MusicPlaylistState> {
  // int index = 0;

  late List<SongModel> musicModel = [];
  bool onTapPauseGlobal = true;
  int indexMusic = 0;
  bool isPlaying = false;
  OnAudioQuery audioQuery = OnAudioQuery();
  late final AudioPlayer audioPlayer;
  MusicPlaylistCubit() : super(MusicPlaylistInitial());

  void downloadMusics() async {
    emit(MusicPlaylistLoading());
    musicModel = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    // await Future.delayed(
    //   const Duration(milliseconds: 1500),
    // );
    emit(
      MusicPlaylistLaded(
        musicList: musicModel,
      ),
    );
  }

  void onTapMusicItem({required SongModel music, required int index}) {
    indexMusic = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(music.uri!)));
      audioPlayer.play();
      isPlaying = true;
    } on Exception {
      log("sorry");
      emit(const MusicPlaylistError(message: "Sorry"));
    }
    emit(
      MusicPlaylistLaded(
        musicList: musicModel,
        musicModel: music,
        index: index,
      ),
    );
  }

  Future<void> stop() async {
    // audioPlayer.stop();
    // emit(
    //   MusicPlaylistLaded(
    //     musicList: musicModel,
    //   ),
    // );
  }
  void onSeekMusic(Duration duration) {
    audioPlayer.seek(duration);
    // audioPlayer.play();
  }

  void onTapPause() {
    // if (indexMusic == 0) {
    //   try {
    //     audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    //     audioPlayer.play();
    //     isPlaying = true;
    //   } on Exception {
    //     log("sorry");
    //     emit(const MusicPlaylistError(message: "Sorry"));
    //   }
    // } else 
    if (isPlaying) {
      isPlaying = false;
      audioPlayer.stop();
    } else {
      isPlaying = true;
      audioPlayer.play();
    }
    emit(MusicPlaylistLoading());
    emit(
      MusicPlaylistLaded(
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );
  }

  void onTapLeftBack() {
    audioPlayer.seekToNext();
    indexMusic--;
    if (indexMusic < 0) {
      indexMusic = musicModel.length - 1;
    }
    isPlaying = true;
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    audioPlayer.play();
    emit(
      MusicPlaylistLaded(
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );
  }

  void onTapNext() {
    audioPlayer.seekToNext();
    indexMusic++;
    if (indexMusic > musicModel.length - 1) {
      indexMusic = 0;
    }
    isPlaying = true;
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    audioPlayer.play();
    emit(
      MusicPlaylistLaded(
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );    
  }

  playSong(SongModel music) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(music.uri!)));
      audioPlayer.play();
      isPlaying = true;
    } on Exception {
      log('Cannot Parse song');
    }
  }

  void setAudioPlayer(AudioPlayer audioPlayer) {
    this.audioPlayer = audioPlayer;
  }
}
