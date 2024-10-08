import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Palette {
  static const primary = Color(0xFF58CC02);
  static const primaryButtonStroke = Color(0xFF58A700);
  static const primaryShadow = Color(0xFF58A700);
  static const primaryText = Color(0xFF4A4A4A);
  static const primaryFill = Color(0xFFD7FFB8);

  static const primaryVariant = Color(0xFF1CB0F6);
  static const primaryVariantStroke = Color(0xFF1899D6);
  static const primaryVariantShadow = Color(0xFF1899D6);
  static const primaryVariantText = Color(0xFF1899D6);

  static const secondary = Color(0xFFFFFFFF);
  static const secondaryStroke = Color(0xFFE5E5E5);
  static const secondaryVariant = Color(0xFFDDF4FF);
  static const secondaryVariantStroke = Color(0xFF84D8FF);
  static const secondaryText = Color(0xFFAFAFAF);

  static const tertiary = Color(0xFFFFC800);
  static const onTertiary = Color(0xFFFFE279);

  static const error = Color(0xFFFD4D50);
  static const errorShadow = Color(0xFFD63E36);
  static const errorFill = Color(0xFFFEC1C2);

  static const textFieldFill = Color(0xFFF7F7F7);
  static const PrimaryShadowDarker = Color(0xFF447F01);
  static const resultCardBadFill = Color(0xFFD63E36);

  static const blackColor = Color(0xFF000000);
  static var lightModeAppTheme = ThemeData.light().copyWith(
    primaryColor: Palette.primary,
    scaffoldBackgroundColor: Palette.secondary,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: Palette.secondary),
      toolbarHeight: 90.h,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      color: Palette.primaryButtonStroke,
      elevation: 0,
      titleTextStyle: TextStyles.titleTextStyle,
    ),
  );
}
