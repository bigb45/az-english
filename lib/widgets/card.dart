import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
      },
      onTap: () {
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
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding8),
                  child: Center(child: widget.child),
                ),
              ),
            )
          : Transform.translate(
              offset: Offset(0, isPressed ? 3 : 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isPressed
                          ? Palette.secondaryVariantStroke
                          : Palette.secondaryStroke,
                      width: 2),
                  color:
                      isPressed ? Palette.secondaryVariant : Palette.secondary,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isPressed
                      ? null
                      : [
                          BoxShadow(
                            color: isPressed
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                            offset: const Offset(0, 2),
                            blurRadius: 0,
                          ),
                        ],
                ),
                width: 170.w,
                height: 170.h,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 10.sp),
                  child: Center(child: widget.child),
                ),
              ),
            ),
    );
  }
}
