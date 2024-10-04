import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  const DrawerActionButton({
    super.key,
    required this.onPressed,
    @Deprecated("use text instead for automatic text color and style")
    this.child,
    this.text,
  });

  @override
  State<DrawerActionButton> createState() => DrawerActionButtonState();
}

class DrawerActionButtonState extends State<DrawerActionButton> {
  var isPressed = false;
  Color textColor = Palette.secondary;
  @override
  void initState() {
    textColor = Palette.secondary;
    if (widget.onPressed == null) {
      textColor = Palette.secondaryStroke;
    }
    super.initState();
  }

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
      onTap: widget.onPressed,
      child: widget.onPressed == null
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Palette.secondaryStroke.withOpacity(0.5), BlendMode.srcATop),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.secondaryStroke,
                  border:
                      Border.all(color: Palette.primaryButtonStroke, width: 2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                width: 48.w,
                height: 48.w,
                child: Center(
                  child: widget.child ??
                      Text(
                        widget.text!.toUpperCase(),
                        style: TextStyles.buttonTextStyle.copyWith(
                          color: Palette.primaryText,
                        ),
                      ),
                ),
              ),
            )
          : Transform.translate(
              offset: Offset(0, isPressed ? 3 : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.primary,
                  border:
                      Border.all(color: Palette.primaryButtonStroke, width: 2),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: isPressed
                      ? null
                      : [
                          const BoxShadow(
                            color: Palette.PrimaryShadowDarker,
                            offset: Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                ),
                width: 48.w,
                height: 48.w,
                child: _buildCircularSvgIcon(
                  "assets/images/app_bar_action_button_icon.svg",
                ),
              ),
            ),
    );
  }
}

Widget _buildCircularSvgIcon(String assetPath) {
  return Container(
    width: 40.0,
    height: 40.0,
    decoration: BoxDecoration(
        color: Colors.transparent,
        // border: Border.all(color: Colors.black.withOpacity(0.2), width: 2),
        borderRadius: BorderRadius.circular(12)),
    child: ClipOval(
      child: SvgPicture.asset(
        assetPath,
        fit: BoxFit.scaleDown,
      ),
    ),
  );
}
