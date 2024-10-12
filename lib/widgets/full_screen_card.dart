import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenCard extends StatelessWidget {
  final String imageUrl;

  const FullScreenCard({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) {
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      );
                    },
                    imageUrl: imageUrl,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit
                        .contain, // Stretches smaller images to cover the entire screen
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
