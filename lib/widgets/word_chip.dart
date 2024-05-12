import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordChip extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isSelected;
  const WordChip({
    super.key,
    this.isSelected = false,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed == null ? null : onPressed!();
      },
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Palette.secondaryStroke, width: 2),
              color: isSelected ? Palette.secondaryStroke : Palette.secondary,
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
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.padding8, vertical: Constants.padding8),
              child: Center(
                  child: Text(
                text,
                style: isSelected
                    ? TextStyles.wordChipTextStyle
                        .copyWith(color: Palette.secondaryStroke)
                    : TextStyles.wordChipTextStyle,
                textAlign: TextAlign.center,
              )),
            ),
          )
        ],
      ),
    );
  }
}
