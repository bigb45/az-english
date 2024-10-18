import 'package:ez_english/theme/palette.dart';
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
      ),
    )..addListener(listener);
  }

  void listener() {
    if (mounted && _controller.value.isReady) {
      setState(() {
        _isPlayerReady = true; // Set this to true when the player is ready
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isPlayerReady && !_controller.value.isFullScreen
          ? AppBar(
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Colors.white,
              title: const Text('Video Player'),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Palette.primaryText,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onEnded: (data) {},
        onReady: () {
          _isPlayerReady = true;
          if (_controller.value.isReady) {
            _controller.toggleFullScreenMode();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
