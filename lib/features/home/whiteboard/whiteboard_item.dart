import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/whiteboard/whiteboard_model.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/full_screen_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WhiteboardItem extends StatefulWidget {
  final WhiteboardModel whiteboardModel;
  final int index;
  const WhiteboardItem({
    super.key,
    required this.whiteboardModel,
    required this.index,
  });

  @override
  State<WhiteboardItem> createState() => _WhiteboardItemState();
}

class _WhiteboardItemState extends State<WhiteboardItem> {
  final innerRadius = 10.0;
  final outerradius = 8.0;
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FullScreenCard(imageUrl: widget.whiteboardModel.imageUrl),
          ),
        );
      },
      child: Transform.translate(
        offset: Offset(0, isPressed ? 3 : 0),
        child: Container(
          width: 180.w,
          height: 240.h,
          decoration: BoxDecoration(
            color: Palette.secondary,
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(outerradius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 0,
                offset: isPressed ? const Offset(0, 0) : const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(outerradius),
            child: Stack(
              children: [
                Positioned(
                    top: 3.h, left: 10.w, child: Text("#${widget.index}")),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Palette.blackColor.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ]),
                      child: Hero(
                        tag: widget.whiteboardModel.imageUrl,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.whiteboardModel.imageUrl,
                          placeholder: (context, url) => SvgPicture.asset(
                            "assets/icons/whiteboard.svg",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Palette.secondary.withOpacity(0.8),
                    ),
                    height: 30.h,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Constants.padding8),
                      child: Center(
                        child: Text(
                          widget.whiteboardModel.title,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16.sp,
                            color: Palette.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
