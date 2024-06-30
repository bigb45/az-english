import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordChipTextField extends StatelessWidget {
  // final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const WordChipTextField({
    super.key,
    // required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Palette.secondaryStroke, width: 2),
        color: Palette.secondary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Palette.secondaryStroke,
            offset: Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Constants.padding8),
        child: Center(
          child: TextField(
            // controller: controller,
            onChanged: onChanged,
            style: TextStyles.wordChipTextStyle,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
