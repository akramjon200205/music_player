// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class MusicPlaylistState extends Equatable {
  const MusicPlaylistState();

  @override
  List<Object> get props => [];
}

class MusicPlaylistInitial extends MusicPlaylistState {}

class MusicPlaylistLoading extends MusicPlaylistState {}

// ignore: must_be_immutable
class MusicPlaylistLoaded extends MusicPlaylistState {
  List<SongModel> musicList;
  SongModel? musicModel;
  int index;
  String position;

  MusicPlaylistLoaded({
    required this.musicList,
    this.musicModel,
    this.index = 0,
    this.position = "0 : 00",
  });

  @override
  List<Object> get props => [musicList, index];
}

class MusicPlayListPlay extends MusicPlaylistState {}

class MusicPlaylistError extends MusicPlaylistState {
  final String message;
  const MusicPlaylistError({required this.message});
}
