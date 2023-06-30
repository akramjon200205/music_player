import 'dart:developer' as developer;
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'music_playlist_state.dart';
import 'dart:math';

class MusicPlaylistCubit extends Cubit<MusicPlaylistState> {
  late List<SongModel> musicList = [];
  late List<int> favoriteMusic = [];

  late File filePathDeletingMusic;
  late final AudioPlayer audioPlayer;

  int indexMusic = 0;

  bool onTaprepeat = false;
  bool isPlaying = false;
  bool onTap = false;

  OnAudioQuery audioQuery = OnAudioQuery();
  CarouselController carouselController = CarouselController();
  SharedPreferences? preferences;

  MusicPlaylistCubit() : super(MusicPlaylistInitial());

  void downloadMusics() async {
    preferences = await SharedPreferences.getInstance();
    emit(MusicPlaylistLoading());
    indexMusic = preferences?.getInt("counter") ?? 0;
    musicList = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
      ),
    );
  }

  void onTapMusicItem({required SongModel music, required int index}) async {
    indexMusic = index;

    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(music.uri!)));
      audioPlayer.play();
      isPlaying = true;
      if (onTap == false) onTap = true;
    } on Exception {
      developer.log("sorry");
      emit(const MusicPlaylistError(message: "Sorry"));
    }
    emit(MusicPlaylistLoading());
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: music,
        index: indexMusic,
      ),
    );
  }

  void onSeekMusic(Duration duration) async {
    audioPlayer.seek(duration);
  }

  void onTapPause() async {
    preferences = await SharedPreferences.getInstance();
    if (isPlaying) {
      isPlaying = false;
      audioPlayer.pause();
    } else {
      if (preferences?.getInt("counter") == null && indexMusic == 0 && onTap == false) {
        audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!),
          ),
        );
        onTap = true;
      }
      if (preferences?.getInt("counter") == indexMusic && onTap == false) {
        audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!),
          ),
        );
        onTap = true;
      }

      audioPlayer.play();
      isPlaying = true;
    }

    emit(MusicPlaylistLoading());
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }

  void onTapLeftBack() async {
    audioPlayer.seekToNext();
    indexMusic--;
    preferences = await SharedPreferences.getInstance();
    if (indexMusic >= 0) {
      preferences?.setInt("counter", indexMusic);
    }
    if (indexMusic < 0) {
      indexMusic = musicList.length - 1;
      preferences?.setInt("counter", indexMusic);
    }
    isPlaying = true;
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(
          musicList[preferences?.getInt("counter") ?? indexMusic].uri!,
        ),
      ),
    );
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }

  void onTapLeftBackNowPlaying() async {
    audioPlayer.seekToNext();
    indexMusic--;
    preferences = await SharedPreferences.getInstance();
    if (indexMusic >= 0) {
      preferences?.setInt("counter", indexMusic);
    }
    if (indexMusic < 0) {
      indexMusic = musicList.length - 1;
      preferences?.setInt("counter", indexMusic);
    }
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    isPlaying = true;
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(
          musicList[preferences?.getInt("counter") ?? indexMusic].uri!,
        ),
      ),
    );
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }

  void onTapNext() async {
    audioPlayer.seekToNext();
    indexMusic++;
    preferences = await SharedPreferences.getInstance();
    preferences?.setInt("counter", indexMusic);
    if ((preferences?.getInt("counter") ?? indexMusic) > musicList.length - 1) {
      indexMusic = 0;
      preferences?.setInt("counter", 0);
    }
    isPlaying = true;
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(
          musicList[preferences?.getInt("counter") ?? indexMusic].uri!,
        ),
      ),
    );
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }

  void onTapNextNowPlaying() async {
    audioPlayer.seekToNext();
    indexMusic++;
    preferences = await SharedPreferences.getInstance();
    preferences?.setInt("counter", indexMusic);
    if ((preferences?.getInt("counter") ?? indexMusic) > musicList.length - 1) {
      indexMusic = 0;
      preferences?.setInt("counter", indexMusic);
    }
    isPlaying = true;
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(
          musicList[preferences?.getInt("counter") ?? indexMusic].uri!,
        ),
      ),
    );
    audioPlayer.play();

    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }

  void setAudioPlayer(AudioPlayer audioPlayer) {
    this.audioPlayer = audioPlayer;
  }

  void repeatFunc() async {
    preferences = await SharedPreferences.getInstance();
    if (onTaprepeat == true) {
      audioPlayer.setLoopMode(LoopMode.one);
      onTaprepeat = false;
    } else {
      audioPlayer.setLoopMode(LoopMode.all);
      onTaprepeat = true;
    }
    emit(
      MusicPlaylistLoading(),
    );
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }

  void randomMusicPlay() async {
    preferences = await SharedPreferences.getInstance();
    var random = Random();
    int size = musicList.length;
    int left = indexMusic < 25 ? indexMusic : 25;
    int right = indexMusic + 25 > size ? size - indexMusic : 25;
    int index = -left + random.nextInt(left + right);
    index = index >= 0 ? index + 1 : index;
    indexMusic += index;
    developer.log("$indexMusic");
    preferences?.setInt("counter", indexMusic);
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 500),
    );
    isPlaying = true;
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!),
      ),
    );
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }

  void caruselSliderNext() async {
    preferences = await SharedPreferences.getInstance();
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 500),
    );

    emit(
      MusicPlaylistLoaded(
        musicList: musicList,
        musicModel: musicList[preferences?.getInt("counter") ?? indexMusic],
        index: preferences?.getInt("counter") ?? indexMusic,
      ),
    );
  }
}
