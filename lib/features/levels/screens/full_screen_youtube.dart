import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenYoutube extends StatefulWidget {
  final String videoId;
  const FullScreenYoutube({super.key, required this.videoId});

  @override
  State<FullScreenYoutube> createState() => _FullScreenYoutubeState();
}

class _FullScreenYoutubeState extends State<FullScreenYoutube> {
  late YoutubePlayerController _controller;
  late TextEditingController _seekToController;
  late String videoId;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        // hideControls: true,
      ),
    )..addListener(listener);
    _seekToController = TextEditingController();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {},
      ),
      builder: (context, player) => Scaffold(
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: player,
        ),
      ),
    );
  }
}
