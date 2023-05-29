import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors._();

  static LinearGradient myPlayListBackgroundColor = const LinearGradient(
    colors: [
      Color(0xff1A1335),
      Color(0xff9A434B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.85],
  );
  static const LinearGradient nowPlayingListBackgroundColor = LinearGradient(
    colors: [
      Color(0xff9A434B),
      Color(0xff1A1335),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.1, 0.8],
  );
  static const LinearGradient nowPlayingContainerGradient = LinearGradient(
      colors: [
        Color(0xff23092E),
        Color(0xff7D233D),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.1, 0.8]);
  static LinearGradient myPlayListContainerColor = LinearGradient(
    colors: [
      const Color(0xff1A1335).withOpacity(0.7),
      const Color(0xff370E30).withOpacity(0.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color white = Colors.white;
  static const Color favoriteColor = Color(0xff370E30);
}
