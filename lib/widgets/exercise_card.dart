import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExerciseCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? description;
  final String? image;
  final Color cardBackgroundColor;
  final Color? cardShadowColor;
  final Color? textColor;
  final Section section;

  const ExerciseCard(
      {super.key,
      required this.section,
      required this.onPressed,
      required this.text,
      required this.image,
      required this.cardBackgroundColor,
      this.cardShadowColor,
      this.textColor,
      this.description});

  @override
  State<ExerciseCard> createState() => ExerciseCardState();
}

// TODO: pass progress within section
class ExerciseCardState extends State<ExerciseCard> {
  var isPressed = false;
  late Section section;

  @override
  void initState() {
    section = widget.section;
    super.initState();
  }

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
        widget.onPressed != null ? widget.onPressed!() : null;
      },
      child: !section.isAssigned
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Palette.secondaryStroke.withOpacity(0.5), BlendMode.srcATop),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.secondaryStroke,
                  border: Border.all(color: Palette.secondaryStroke, width: 2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                width: 170.w,
                height: 180.w,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          //TODO: check all conditions
                          section.isAttempted && section.numberOfQuestions != 0
                              ? !section.isCompleted
                                  ? Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${section.numberOfSolvedQuestions.toString()} / ${section.numberOfQuestions.toString()} ",
                                            style: TextStyle(
                                              color: widget.textColor ??
                                                  Palette.secondary,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ProgressBar(
                                            width: 100.w,
                                            value: section.progress,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: 20.w,
                                            height: 20.w,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  offset: const Offset(0, 2),
                                                )
                                              ],
                                              color: Palette.primary,
                                              borderRadius:
                                                  BorderRadius.circular(100.r),
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Palette.secondary,
                                              size: 18.sp,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  offset: const Offset(0, 2),
                                                )
                                              ],
                                            ),
                                          ),
                                          // SizedBox(width: Constants.padding4),
                                          ProgressBar(
                                            width: 80.w,
                                            value: section.progress,
                                          ),
                                        ],
                                      ),
                                    )
                              : Text(
                                  "Not Attempted",
                                  style: TextStyle(
                                      color: widget.textColor ??
                                          Palette.secondaryText,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                      SvgPicture.asset(
                          widget.image ?? 'assets/images/notepad.svg',
                          height: 80),
                      Center(
                        child: Text(
                          widget.text,
                          style: TextStyles.practiceCardMainText.copyWith(
                            color: Palette.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Transform.translate(
              offset: Offset(0, isPressed ? 4 : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isPressed
                      ? null
                      : [
                          BoxShadow(
                            color: isPressed
                                ? Palette.secondary
                                : darkenColor(widget.cardBackgroundColor, 0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                ),
                width: 170.w,
                height: 180.w,
                child: Padding(
                    padding: EdgeInsets.all(Constants.padding6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            section.isAttempted
                                ? !section.isCompleted
                                    ? Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${section.numberOfSolvedQuestions.toString()} / ${section.numberOfQuestions.toString()} ",
                                              style: TextStyle(
                                                color: widget.textColor ??
                                                    Palette.secondary,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ProgressBar(
                                              width: 80.w,
                                              value: section.progress,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              width: 20.w,
                                              height: 20.w,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                  )
                                                ],
                                                color: Palette.primary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r),
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Palette.secondary,
                                                size: 18.sp,
                                                shadows: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                  )
                                                ],
                                              ),
                                            ),
                                            // SizedBox(width: Constants.padding4),
                                            ProgressBar(
                                              width: 100.w,
                                              value: section.progress,
                                            ),
                                          ],
                                        ),
                                      )
                                : Text(
                                    "Not Attempted",
                                    style: TextStyle(
                                        color: widget.textColor ??
                                            Palette.secondary,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ],
                        ),
                        SvgPicture.asset(
                          widget.image ?? 'assets/images/notepad.svg',
                        ),
                        Center(
                          child: Text(
                            widget.text,
                            style: TextStyles.practiceCardMainText,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}

Color darkenColor(Color? color, double factor) {
  assert(factor >= 0 && factor <= 1);
  if (color == null) return const Color(0xFF000000);
  // Calculate the new color components
  int red = (color.red * (1 - factor)).round();
  int green = (color.green * (1 - factor)).round();
  int blue = (color.blue * (1 - factor)).round();
  // Create and return the new color
  return Color.fromARGB(color.alpha, red, green, blue);
}
