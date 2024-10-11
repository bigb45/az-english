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
              minScale:
                  1.0, // Minimum scale to prevent shrinking below the original size
              maxScale: 4.0, // Maximum zoom level
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CachedNetworkImage(
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
