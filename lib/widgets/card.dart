import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

class SelectableCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  const SelectableCard({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<SelectableCard> createState() => SelectableCardState();
}

class SelectableCardState extends State<SelectableCard> {
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
      child: widget.onPressed == null
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Palette.secondaryStroke.withOpacity(0.5), BlendMode.srcATop),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.secondaryStroke,
                  border: Border.all(color: Palette.secondaryStroke, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 180,
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(child: widget.child),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: isSelected
                        ? Palette.secondaryVariantStroke
                        : Palette.secondaryStroke,
                    width: 2),
                color:
                    isSelected ? Palette.secondaryVariant : Palette.secondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? Palette.secondaryVariantStroke
                        : Palette.secondaryStroke,
                    offset: const Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              width: 180,
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(child: widget.child),
              ),
            ),
    );
  }
}
