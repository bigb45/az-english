// ignore_for_file: prefer_const_constructors

import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: const [
                CustomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  const CustomButton({super.key});

  @override
  State<CustomButton> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
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
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Palette.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isPressed
              ? null
              : [
                  BoxShadow(
                    color: Palette.primaryShadow,
                    offset: Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
        ),
        width: 300,
        height: 48,
        child: Center(
          child: Text(
            "CONTINUE",
            style: TextStyle(
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
