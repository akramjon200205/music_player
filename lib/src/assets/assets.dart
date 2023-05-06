abstract class Assets {
  const Assets._();

  // ignore: library_private_types_in_public_api
  static _Icons get icons => const _Icons();

  // ignore: library_private_types_in_public_api
  static _Images get images => const _Images();
  // ignore: library_private_types_in_public_api
  static _Musics get musics => const _Musics();
}

abstract class _AssetsHolder {
  final String basePath;

  const _AssetsHolder(this.basePath);
}

class _Icons extends _AssetsHolder {
  const _Icons() : super('assets/icons');

  String get backLeft => '$basePath/back_left.svg';
  String get menu => '$basePath/menu.svg';
  String get nextRight => '$basePath/next_right.svg';
  String get pause => '$basePath/pause.svg';
  String get prevLeft => '$basePath/prev_left.svg';
  String get reshare => '$basePath/reshare.svg';
  String get reshareOne => '$basePath/reshare_one.svg';

  String get soundWave => '$basePath/sound_wave.svg';
  String get pausePlayer => '$basePath/pause_player.svg';
  String get musicNote => '$basePath/music_note.svg';
  String get playMusic => '$basePath/play_music.svg';
  String get randomMusic => '$basePath/random_music.svg';
  String get favorite => '$basePath/favoryte.svg';
  String get valume => '$basePath/valume.svg';
  String get valumeMute => '$basePath/valume_mute.svg';

  String get repeat => '$basePath/repeat.png';
}

class _Images extends _AssetsHolder {
  const _Images() : super('assets/images');
  String get pictureMusic => '$basePath/picture_music.png';
  String get secondMusic => '$basePath/second_music.png';
  String get thirdMusic => '$basePath/third_music.png';
  String get fourthMusic => '$basePath/fourth_music.png';
  String get fivethMusic => '$basePath/fiveth_music.png';
  String get sixthMusic => '$basePath/sixth_music.png';
  String get musicCardPicture => '$basePath/music_card_picture.png';
}

class _Musics extends _AssetsHolder {
  const _Musics() : super('assets/music');

  String get serenaSafari => '$basePath/serena_safari_remix.mp3';
}
