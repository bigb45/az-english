import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioControlButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final AudioControlType type;
  const AudioControlButton({
    super.key,
    required this.onPressed,
    required this.type,
  });

  @override
  State<AudioControlButton> createState() => AudioControlButtonState();
}

class AudioControlButtonState extends State<AudioControlButton> {
  var isSelected = false;
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });

        widget.onPressed;
      },
      child: Transform.translate(
        offset: Offset(0, isPressed ? 5 : 0),
        child: Container(
          decoration: BoxDecoration(
            color: Palette.primaryVariant,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: isPressed
                ? null
                : const [
                    BoxShadow(
                      color: Palette.primaryVariantShadow,
                      offset: Offset(0, 5),
                      blurRadius: 0,
                    ),
                  ],
          ),
          width: 100.w,
          height: 120.h,
          child: Center(
              child: switch (widget.type) {
            AudioControlType.microphone => Icon(
                Icons.mic,
                color: Palette.secondary,
                size: 80.r,
              ),
            AudioControlType.speaker => Icon(
                Icons.volume_up,
                color: Palette.secondary,
                size: 80.r,
              ),
          }),
        ),
      ),
    );
  }
}

enum AudioControlType {
  microphone,
  speaker,
}
