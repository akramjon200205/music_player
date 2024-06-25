import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());
  List<int> musicListCubit = MusicPlaylistCubit().favoriteMusic;
  List<SongModel> musicListFavorite = [];
  int indexMusic = 0;
  bool isPlaying = false;
}
