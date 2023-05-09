

// import 'package:audio_service/audio_service.dart';

// import 'package:audio_query/audio_query.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';

// enum PlayerState { stopped, playing, paused }

// class MusicPlayerCubit extends Cubit<PlayerState> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   late final List<MediaItem> _songs;

//   MusicPlayerCubit() : super(PlayerState.stopped);

//   Future<void> init() async {
//     final audioQuery = AudioQuery();
//     _songs = await audioQuery.getSongs();
//   }

//   Future<void> play(MediaItem song) async {
//     if (state == PlayerState.stopped) {
//       await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(song.filePath!)));
//       emit(PlayerState.playing);
//     } else if (state == PlayerState.paused) {
//       _audioPlayer.play();
//       emit(PlayerState.playing);
//     }
//   }

//   Future<void> pause() async {
//     if (state == PlayerState.playing) {
//       _audioPlayer.pause();
//       emit(PlayerState.paused);
//     }
//   }

//   Future<void> stop() async {
//     await _audioPlayer.stop();
//     emit(PlayerState.stopped);
//   }
// }

// class MusicPlayerScreen extends StatefulWidget {
//   const MusicPlayerScreen({Key? key}) : super(key: key);

//   @override
//   _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
// }

// class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
//   late final MusicPlayerCubit _cubit;

//   @override
//   void initState() {
//     super.initState();
//     _cubit = MusicPlayerCubit();
//     _cubit.init();
//   }

//   @override
//   void dispose() {
//     _cubit.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Music Player'),
//       ),
//       body: BlocBuilder<MusicPlayerCubit, PlayerState>(
//         bloc: _cubit,
//         builder: (context, state) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_cubit._songs.isNotEmpty)
//                 Text(
//                   _cubit._songs.first.title ?? '',
//                   style: const TextStyle(fontSize: 24),
//                 ),
//               const SizedBox(height: 16),
//               if (state == PlayerState.playing)
//                 IconButton(
//                   icon: const Icon(Icons.pause),
//                   onPressed: _cubit.pause,
//                 )
//               else if (state == PlayerState.paused)
//                 IconButton(
//                   icon: const Icon(Icons.play_arrow),
//                   onPressed: () => _cubit.play(_cubit._songs.first),
//                 )
//               else
//                 IconButton(
//                   icon: const Icon(Icons.play_arrow),
//                   onPressed: () => _cubit.play(_cubit._songs.first),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }