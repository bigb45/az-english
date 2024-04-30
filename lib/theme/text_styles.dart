// core/text_styles.dart

import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle cardHeader = TextStyle(
    fontSize: 40.sp,
    color: Palette.secondaryText,
    fontWeight: FontWeight.w800,
    fontFamily: "Inter",
  );
  static TextStyle cardText = TextStyle(
    fontSize: 13.sp,
    color: Palette.secondaryText,
    fontWeight: FontWeight.w800,
    fontFamily: "Inter",
  );
  static TextStyle practiceCardMainText = TextStyle(
      color: Palette.secondary,
      fontFamily: 'Inter',
      fontSize: 20.sp,
      fontWeight: FontWeight.w700);
  static TextStyle practiceCardSecondaryText = TextStyle(
      color: Palette.primaryText,
      fontFamily: 'Inter',
      fontSize: 20.sp,
      fontWeight: FontWeight.w700);

  static TextStyle titleTextStyle = TextStyle(
      color: Palette.secondary,
      fontFamily: 'Inter',
      fontSize: 24.sp,
      fontWeight: FontWeight.w700);

  static TextStyle subtitleTextStyle = TextStyle(
      color: Palette.secondary,
      fontFamily: 'Inter',
      fontSize: 17.sp,
      fontWeight: FontWeight.w400);

  static TextStyle optionTextStyle = TextStyle(
      color: Palette.primaryText,
      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w700);
  static TextStyle readingPracticeTextStyle = TextStyle(
      color: Palette.primaryText,
      fontFamily: 'Inter',
      fontSize: 20.sp,
      fontWeight: FontWeight.w400);
  static TextStyle readingPracticeSecondaryTextStyle = TextStyle(
      color: Palette.secondaryText,
      fontFamily: 'Inter',
      fontSize: 13.sp,
      fontWeight: FontWeight.w400);
}
