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
}
