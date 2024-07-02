import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool selected;
  final Widget child;
  const SelectableCard(
      {super.key,
      required this.onPressed,
      required this.child,
      this.selected = false});

  @override
  State<SelectableCard> createState() => SelectableCardState();
}

class SelectableCardState extends State<SelectableCard> {
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
      },
      onTap: () {
        widget.onPressed != null ? widget.onPressed!() : null;
      },
      child: widget.onPressed == null
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: Palette.secondaryStroke, width: 2),
                color: Palette.secondary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              width: 170.w,
              height: 170.w,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 10.sp),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Palette.secondaryStroke.withOpacity(0.5),
                      BlendMode.srcATop),
                  child: Center(child: widget.child),
                ),
              ),
            )
          : Transform.translate(
              offset: Offset(0, isPressed ? 3 : 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isPressed || widget.selected
                          ? Palette.secondaryVariantStroke
                          : Palette.secondaryStroke,
                      width: 2),
                  color: isPressed || widget.selected
                      ? Palette.secondaryVariant
                      : Palette.secondary,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isPressed
                      ? null
                      : [
                          BoxShadow(
                            color: isPressed || widget.selected
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                            offset: const Offset(0, 2),
                            blurRadius: 0,
                          ),
                        ],
                ),
                width: 170.w,
                height: 170.w,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 10.sp),
                  child: Center(child: widget.child),
                ),
              ),
            ),
    );
  }
}
