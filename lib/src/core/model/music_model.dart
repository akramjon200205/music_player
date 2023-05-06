class MusicModel {
  MusicModel({
    required this.image,
    required this.musicName,
    required this.songWriterName,
    required this.time,
  });

  String? musicName;
  String? songWriterName;
  String? time;
  String? image;

  MusicModel copyWith({
    String? musicName,
    String? songWriterName,
    String? time,
    String? image,
  }) {
    return MusicModel(
      image: image ?? this.image,
      musicName: musicName ?? this.musicName,
      songWriterName: songWriterName ?? this.songWriterName,
      time: time ?? this.time,
    );
  }
}
