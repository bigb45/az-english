import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordChip extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  const WordChip({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<WordChip> createState() => WordChipState();
}

class WordChipState extends State<WordChip> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onPressed!();
      },
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
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
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.padding8, vertical: Constants.padding8),
              child: Center(
                  child: Text(
                widget.text,
                style: TextStyles.wordChipTextStyle,
                textAlign: TextAlign.center,
              )),
            ),
          )
        ],
      ),
    );
  }
}
