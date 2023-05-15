import 'dart:developer' as developer;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'music_playlist_state.dart';
import 'dart:math';

class MusicPlaylistCubit extends Cubit<MusicPlaylistState> {
  // int index = 0;

  late List<SongModel> musicModel = [];
  int indexMusic = 0;
  bool onTaprepeat = false;
  bool isPlaying = false;
  OnAudioQuery audioQuery = OnAudioQuery();
  CarouselController carouselController = CarouselController();
  var sliderPosition;

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
    emit(
      MusicPlaylistLoaded(
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
      developer.log("sorry");
      emit(const MusicPlaylistError(message: "Sorry"));
    }
    emit(
      MusicPlaylistLoaded(
        musicList: musicModel,
        musicModel: music,
        index: index,
      ),
    );
  }

  void onSeekMusic(Duration duration) {
    audioPlayer.seek(duration);
  }

  void onTapPause() {
    if (isPlaying) {
      isPlaying = false;
      audioPlayer.stop();
    } else {
      isPlaying = true;
      audioPlayer.play();
    }

    emit(MusicPlaylistLoading());
    emit(
      MusicPlaylistLoaded(
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
    audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );
  }

  void onTapLeftBackNowPlaying() {
    audioPlayer.seekToNext();
    indexMusic--;
    if (indexMusic < 0) {
      indexMusic = musicModel.length - 1;
    }
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 800),
    );
    isPlaying = true;
    audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
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
    audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );
  }

  void onTapNextNowPlaying() {
    audioPlayer.seekToNext();
    indexMusic++;
    if (indexMusic > musicModel.length - 1) {
      indexMusic = 0;
    }
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 800),
    );
    isPlaying = true;
    audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );
  }

  onNextMusicPLay(double duration) {
    final durationTime = Duration(
      milliseconds: (audioPlayer.duration == null
              ? 1
              : audioPlayer.duration!.inMilliseconds * duration / 100)
          .toInt(),
    );
    if (durationTime == audioPlayer.duration) {
      audioPlayer.seekToNext();
      indexMusic++;
      if (indexMusic > musicModel.length - 1) {
        indexMusic = 0;
      }
      isPlaying = true;
      audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
      audioPlayer.play();
      emit(
        MusicPlaylistLoaded(
          musicList: musicModel,
          musicModel: musicModel[indexMusic],
          index: indexMusic,
        ),
      );
    }
  }

  void setAudioPlayer(AudioPlayer audioPlayer) {
    this.audioPlayer = audioPlayer;
  }

  void repeatFunc() {
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
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );
  }

  void randomMusicPlay() async {
    var random = Random();
    indexMusic = random.nextInt(musicModel.length);
    carouselController.animateToPage(
      indexMusic,
      duration: const Duration(milliseconds: 800),
    );
    isPlaying = true;
    audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(musicModel[indexMusic].uri!)));
    audioPlayer.play();
    emit(
      MusicPlaylistLoaded(
        musicList: musicModel,
        musicModel: musicModel[indexMusic],
        index: indexMusic,
      ),
    );
  }

  String songPosition(dynamic position) {
    int durationInSeconds = (position.duration! ~/ 1000).toInt();
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    if (seconds ~/ 10 < 1) {
      return '$minutes : 0$seconds';
    }
    return '$minutes : $seconds';
  }

  // getSliderPosition() async {
  //   sliderPosition = audioPlayer.positionStream.listen((position) {
  //     print(
  //         'Current position: ${position.inMinutes}:${position.inSeconds.remainder(60)}');
  //   });
  // }
}
