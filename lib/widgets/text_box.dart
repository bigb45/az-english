import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextBox extends StatelessWidget {
  final String paragraphText;
  final int maxLineNum;
  final TextStyle? secondaryTextStyle;

  const CustomTextBox({
    Key? key,
    required this.paragraphText,
    required this.maxLineNum,
    this.secondaryTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: paragraphText,
      readOnly: true, // User cannot edit the text
      maxLines: maxLineNum,
      style: secondaryTextStyle ?? TextStyles.readingPracticeTextStyle,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: Palette.secondaryText,
            width: 2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: Palette.secondaryVariantStroke,
            width: 2.w,
          ),
        ),
      ),
    );
  }
}
