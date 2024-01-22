import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideo extends StatefulWidget{
  final videoID;

  const PlayVideo({Key? key, required this.videoID}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();

}

class _PlayVideoState extends State<PlayVideo>{


  late YoutubePlayerController _controller;
  @override
  void initState(){


    _controller = YoutubePlayerController(
        initialVideoId: widget.videoID!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Container()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: const ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}