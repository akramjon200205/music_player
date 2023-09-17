import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/my_playlist/presentation/cubit/music_playlist_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'deleting_state.dart';

class DeletingMusicCubit extends Cubit<DeletingMusicState> {
  DeletingMusicCubit() : super(DeletingMusicInitial());
  List<SongModel> deletingMusiclist = [];
  int index = 0;

  Future<void> deletingMusics() async {
    emit(DeletingMusicLoading());
    emit(
      DeletingMusicLoaded(
        musicList: deletingMusiclist,
        index: index,
      ),
    );
  }
}
