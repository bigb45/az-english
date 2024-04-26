import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExerciseCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? description;
  final String? image;
  final Color? cardBackgroundColor;
  final Color? cardShadowColor;
  final Color? textColor;
  final bool attempted;

  const ExerciseCard(
      {super.key,
      required this.onPressed,
      required this.child,
      required this.image,
      this.cardBackgroundColor,
      this.cardShadowColor,
      this.textColor,
      required this.attempted,
      this.description});

  @override
  State<ExerciseCard> createState() => ExerciseCardState();
}

class ExerciseCardState extends State<ExerciseCard> {
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
        widget.onPressed;
      },
      child: widget.onPressed == null
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Palette.secondaryStroke.withOpacity(0.5), BlendMode.srcATop),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.secondaryStroke,
                  border: Border.all(color: Palette.secondaryStroke, width: 2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                width: 180.w,
                height: 180.w,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: widget.attempted
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          widget.attempted
                              ? Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                    color: Palette.primary,
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Palette.secondary,
                                    size: 18.sp,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                )
                              : Text(
                                  "Not Attempted",
                                  style: TextStyle(
                                      color:
                                          widget.textColor ?? Palette.secondary,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                      SvgPicture.asset(
                          widget.image ?? 'assets/images/notepad.svg',
                          height: 100),
                      Center(child: widget.child),
                    ],
                  ),
                ),
              ),
            )
          : Transform.translate(
              offset: Offset(0, isPressed ? 4 : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.cardBackgroundColor ?? const Color(0xFF34495E),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isPressed
                      ? null
                      : [
                          BoxShadow(
                            color: isPressed
                                ? Palette.secondary
                                : widget.cardShadowColor ??
                                    const Color(0xFF00144A),
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                ),
                width: 180.w,
                height: 180.w,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: widget.attempted
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          widget.attempted
                              ? Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                    color: Palette.primary,
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Palette.secondary,
                                    size: 18.sp,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                )
                              : Text(
                                  "Not Attempted",
                                  style: TextStyle(
                                      color:
                                          widget.textColor ?? Palette.secondary,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                      SvgPicture.asset(
                          widget.image ?? 'assets/images/notepad.svg',
                          height: 100),
                      Center(child: widget.child),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
