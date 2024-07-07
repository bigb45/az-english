import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatefulWidget {
  final ButtonType type;
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  const Button({
    super.key,
    this.type = ButtonType.primary,
    required this.onPressed,
    @Deprecated("use text instead for automatic text color and style")
    this.child,
    this.text,
  });

  @override
  State<Button> createState() => ButtonState();
}

class ButtonState extends State<Button> {
  var isPressed = false;
  Color textColor = Palette.secondary;
  @override
  void initState() {
    textColor = switch (widget.type) {
      ButtonType.primary => Palette.secondary,
      ButtonType.primaryVariant => Palette.secondary,
      ButtonType.error => Palette.secondary,
      ButtonType.secondary => Palette.primaryVariant,
      ButtonType.secondarySelected => Palette.primaryVariantText,
    };
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
                  border: Border.all(color: Palette.secondaryStroke, width: 2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                width: 382.w,
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
                  color: switch (widget.type) {
                    ButtonType.primary => Palette.primary,
                    ButtonType.primaryVariant => Palette.primaryVariant,
                    ButtonType.error => Palette.error,
                    ButtonType.secondary => Palette.secondary,
                    ButtonType.secondarySelected => Palette.secondaryVariant,
                  },
                  border: switch (widget.type) {
                    ButtonType.secondary =>
                      Border.all(color: Palette.secondaryStroke, width: 2),
                    ButtonType.secondarySelected => Border.all(
                        color: Palette.secondaryVariantStroke, width: 2),
                    _ => null
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isPressed
                      ? null
                      : [
                          BoxShadow(
                            color: switch (widget.type) {
                              ButtonType.primary => Palette.primaryShadow,
                              ButtonType.primaryVariant =>
                                Palette.primaryVariantShadow,
                              ButtonType.error => Palette.errorShadow,
                              ButtonType.secondary => Palette.secondaryStroke,
                              ButtonType.secondarySelected =>
                                Palette.secondaryVariantStroke,
                            },
                            offset: const Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                ),
                width: 382.w,
                height: 48.w,
                child: Center(
                  child: widget.child ??
                      Text(
                        widget.text!.toUpperCase(),
                        style: TextStyles.buttonTextStyle.copyWith(
                          color: textColor,
                        ),
                      ),
                ),
              ),
            ),
    );
  }
}

// // Button text style
// Text(
//   "CONTINUE",
//   style: TextStyle(
//     color: Palette.secondary,
//     fontFamily: 'Inter',
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//   ),
// ),

enum ButtonType {
  primary,
  primaryVariant,
  secondary,
  secondarySelected,
  error,
}
