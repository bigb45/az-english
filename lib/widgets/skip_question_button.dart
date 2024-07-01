import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkipQuestionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double? size;
  const SkipQuestionButton({
    super.key,
    required this.onPressed,
    this.size,
  });

  @override
  State<SkipQuestionButton> createState() => SkipQuestionButtonState();
}

class SkipQuestionButtonState extends State<SkipQuestionButton> {
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
        widget.onPressed!();
        setState(() {
          isSelected = !isSelected;
        });
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
            height: 60.w,
            child: Icon(
              Icons.navigate_next,
              color: Palette.secondary,
              size: widget.size == null ? 40.r : widget.size! / 2,
            )),
      ),
    );
  }
}
