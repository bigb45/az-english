import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

class WordChip extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  const WordChip({
    super.key,
    required this.onPressed,
    required this.child,
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
        widget.onPressed;
      },
      child:
          // widget.onPressed == null
          //     ? ColorFiltered(
          //         colorFilter: ColorFilter.mode(
          //             Palette.secondaryStroke.withOpacity(0.5), BlendMode.srcATop),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Palette.secondaryStroke,
          //             border: Border.all(color: Palette.secondaryStroke, width: 2),
          //             borderRadius: BorderRadius.circular(16),
          //           ),
          //           height: 44,
          //           child: Center(child: widget.child),
          //         ),
          //       )
          //     :
          Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Palette.secondaryStroke, width: 2),
              color: Palette.secondary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Palette.secondaryStroke,
                  offset: Offset(0, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Center(child: widget.child),
            ),
          )
        ],
      ),
    );
  }
}
