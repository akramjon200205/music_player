// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../core/model/music_model.dart';

abstract class MusicPlaylistState extends Equatable {
  const MusicPlaylistState();

  @override
  List<Object> get props => [];
}

class MusicPlaylistInitial extends MusicPlaylistState {}

class MusicPlaylistLoading extends MusicPlaylistState {}

// ignore: must_be_immutable
class MusicPlaylistLaded extends MusicPlaylistState {
  List musicList;
  MusicModel? musicModel;
  int index;
  bool isPlay;

  MusicPlaylistLaded({
    required this.musicList,
    this.musicModel,
     this.index = 0, 
    this.isPlay = false,
  });

  @override
  List<Object> get props => [musicList, index];
}

class MusicPlaylistError extends MusicPlaylistState {}
