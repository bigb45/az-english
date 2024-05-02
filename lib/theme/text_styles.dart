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
      fontWeight: FontWeight.w400,
      height: 1.5);
  static TextStyle readingPracticeSecondaryTextStyle = TextStyle(
      color: Palette.secondaryText,
      fontFamily: 'Inter',
      fontSize: 13.sp,
      fontWeight: FontWeight.w400);

  static TextStyle bodyMedium = TextStyle(
    height: 2,
    fontSize: 16.sp,
    color: Palette.primaryText,
  );

  static TextStyle bodyLarge = TextStyle(
    height: 2,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: Palette.primaryText,
  );

  static TextStyle buttonTextStyle = TextStyle(
    color: Palette.secondary,
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle showMoreTextStyle = TextStyle(
    color: Palette.primaryVariantShadow,
    fontFamily: 'Inter',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle questionTextStyle = TextStyle(
    color: Palette.primaryText,
    fontFamily: 'Inter',
    fontSize: 19.sp,
    fontWeight: FontWeight.w600,
  );
}
