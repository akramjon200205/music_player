import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool fullscreen = false;
  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: fullscreen == false
          ? AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Video Player",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
      body: Padding(
        padding: fullscreen
            ? EdgeInsets.zero
            : const EdgeInsets.only(
                top: 32.0,
              ),
        child: YoYoPlayer(
          aspectRatio: 16 / 9,
          url: "https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8",
          allowCacheFile: true,
          onCacheFileCompleted: (files) {
            print("Cached file length ::: ${files?.length}");

            if (files != null && files.isNotEmpty) {
              for (var file in files) {
                print('File path ::: ${file.path}');
              }
            }
          },
          onCacheFileFailed: (error) {
            print('Cache file error ::: $error');
          },
          videoStyle: const VideoStyle(
            qualityStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            forwardAndBackwardBtSize: 30.0,
            playButtonIconSize: 40.0,
            playIcon: Icon(
              Icons.add_circle_outline_outlined,
              size: 40.0,
              color: Colors.white,
            ),
            pauseIcon: Icon(
              Icons.remove_circle_outline_outlined,
              size: 40.0,
              color: Colors.white,
            ),
            videoQualityPadding: EdgeInsets.all(5.0),
            // showLiveDirectButton: true,
            // enableSystemOrientationsOverride: false,
          ),
          videoLoadingStyle: VideoLoadingStyle(
            loading: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('image/yoyo_logo.png'),
                    fit: BoxFit.fitHeight,
                    height: 50,
                  ),
                  SizedBox(height: 16.0),
                  Text("Loading video..."),
                ],
              ),
            ),
          ),
          onFullScreen: (value) {
            setState(() {
              if (fullscreen != value) {
                fullscreen = value;
              }
            });
          },
        ),
      ),
    );
  }
}
