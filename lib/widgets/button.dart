import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final ButtonType type;
  final VoidCallback? onPressed;
  final Widget child;
  const Button({
    super.key,
    this.type = ButtonType.primary,
    required this.onPressed,
    required this.child,
  });

  @override
  State<Button> createState() => ButtonState();
}

class ButtonState extends State<Button> {
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
      onTap: widget.onPressed,
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
                width: 382,
                height: 48,
                child: Center(child: widget.child),
              ),
            )
          : Container(
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
                  ButtonType.secondarySelected =>
                    Border.all(color: Palette.secondaryVariantStroke, width: 2),
                  _ => null
                },
                borderRadius: BorderRadius.circular(16),
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
                          offset: const Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
              ),
              width: 382,
              height: 48,
              child: Center(child: widget.child),
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
