 import 'package:on_audio_query/on_audio_query.dart';

String formatTime(SongModel songDuration) {
    int durationInSeconds = (songDuration.duration! ~/ 1000).toInt();
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    if (seconds ~/ 10 < 1) {
      return '$minutes : 0$seconds';
    }
    return '$minutes : $seconds';
  }
