import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/whiteboard/whiteboard_model.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';

class WhiteboardView extends StatelessWidget {
  final WhiteboardModel whiteboardModel;
  const WhiteboardView({super.key, required this.whiteboardModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            whiteboardModel.title,
            style: TextStyles.bodyLarge,
          ),
          Constants.gapH20,
          InteractiveViewer(
              child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    );
                  },
                  imageUrl: whiteboardModel.imageUrl!)),
        ],
      ),
    );
  }
}
