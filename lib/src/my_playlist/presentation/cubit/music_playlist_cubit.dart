import 'dart:developer' as developer;
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'music_playlist_state.dart';
import 'dart:math';

class MusicPlaylistCubit extends Cubit<MusicPlaylistState> {
  late List<SongModel> musicList = [];
  int indexMusic = 0;
  bool onTaprepeat = false;
  bool isPlaying = false;
  OnAudioQuery audioQuery = OnAudioQuery();
  CarouselController carouselController = CarouselController();
  int onTap = 0;
  late File filePathDeletingMusic;
  bool onLongTap = false;

  SharedPreferences? preferences;

  late final AudioPlayer audioPlayer;
  MusicPlaylistCubit() : super(MusicPlaylistInitial());

  void downloadMusics() async {
    preferences = await SharedPreferences.getInstance();
    emit(MusicPlaylistLoading());
    indexMusic = await preferences?.getInt("counter") ?? 0;
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
    } on Exception {
      developer.log("sorry");
      emit(const MusicPlaylistError(message: "Sorry"));
    }
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
      audioPlayer.stop();
    } else {
      if ((indexMusic == preferences?.getInt("counter") || indexMusic == 0) && onTap == 0) {
        audioPlayer
            .setAudioSource(AudioSource.uri(Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!)));
        onTap = 1;
      }
      isPlaying = true;
      audioPlayer.play();
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
    preferences?.setInt("counter", indexMusic);
    if (indexMusic < 0) {
      indexMusic = musicList.length - 1;
    }
    isPlaying = true;
    audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!)));
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
    preferences?.setInt("counter", indexMusic);
    if ((preferences?.getInt("counter") ?? indexMusic) < 0) {
      preferences?.setInt("counter", musicList.length - 1);
      indexMusic = musicList.length - 1;
    }
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 500),
    );
    isPlaying = true;
    audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!)));
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
    audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!)));
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
    audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!)));
    audioPlayer.play();

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
    indexMusic = random.nextInt(musicList.length);
    preferences?.setInt("counter", indexMusic);
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 1000),
    );
    isPlaying = true;
    audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!)));
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

  void deletingMusic() async {
    preferences = await SharedPreferences.getInstance();
    filePathDeletingMusic = await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(musicList[preferences?.getInt("counter") ?? indexMusic].uri!))) as File;
    developer.log("added music model path");
  }
}
