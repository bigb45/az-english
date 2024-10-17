import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String videoId;

  const YouTubeVideoPlayer({Key? key, required this.videoId}) : super(key: key);

  @override
  _YouTubeVideoPlayerState createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  late String videoId;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.videoId) ?? widget.videoId;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
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
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {},
              bottomActions: [
                IconButton(
                    onPressed: () {
                      _controller.pause();
                      context.push('/youtube/${videoId}');
                    },
                    icon: const Icon(
                      Icons.fullscreen,
                      color: Palette.secondary,
                    ))
              ],
            ),
            builder: (context, player) => Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: player,
                ),
              ],
            ),
          ),
          // Button(
          //   onPressed: () {},
          //   text: 'Watch in fullscreen',
          // ),
        ],
      ),
    );
  }
}

// Usage example:
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('YouTube Player Demo'),
//       ),
//       body: const Center(
//         child: YouTubeVideoPlayer(videoId: 'DoKYYLZVU98'), // Pass your video ID here
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: MyHomePage(),
//   ));
// }
