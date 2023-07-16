// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'deleting_cubit.dart';

abstract class DeletingMusicState extends Equatable {
  const DeletingMusicState();

  @override
  List<Object> get props => [];
}

class DeletingMusicInitial extends DeletingMusicState {}

class DeletingMusicLoading extends DeletingMusicState {}

// ignore: must_be_immutable
class DeletingMusicLoaded extends DeletingMusicState {
  List<SongModel> musicList = [];

  int index = 0;

  DeletingMusicLoaded({
    required this.musicList,
    required this.index,
  });
  
}

class MusicPlaylistError extends DeletingMusicState {
  final String message;
  const MusicPlaylistError({required this.message});
}
