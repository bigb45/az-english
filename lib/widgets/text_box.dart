import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextBox extends StatelessWidget {
  final List<TextSpan> textSpans;
  final int maxLineNum;
  final TextStyle? secondaryTextStyle;

  const CustomTextBox({
    Key? key,
    required this.textSpans,
    required this.maxLineNum,
    this.secondaryTextStyle,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.secondaryText,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: RichText(
        maxLines: maxLineNum,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: textSpans,
          style: secondaryTextStyle ?? TextStyles.readingPracticeTextStyle,
        ),
      ),
    );
  }
}
