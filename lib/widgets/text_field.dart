// ignore_for_file: prefer_const_constructors

import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  // TODO: Pass in the required parameters (controller, focusNode, etc.)
  const CustomTextField({super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    Color fillColor = Palette.textFieldFill;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: true,
        onTap: () {
          setState(() {
            fillColor = Palette.error;
          });
        },
        onEditingComplete: () {
          setState(() {
            fillColor = Palette.textFieldFill;
          });
        },
        style: TextStyle(
          color: Palette.primaryText,
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: fillColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Palette.secondaryStroke,
              width: 2,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Palette.error,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Palette.secondaryVariantStroke,
              width: 2,
            ),
          ),
          hintStyle: TextStyle(
            color: Palette.secondaryText,
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          // helperText: "HELPER TEXT",
          // helperStyle: TextStyle(
          //   color: Palette.error,
          //   fontFamily: 'Inter',
          //   fontSize: 12,
          //   fontWeight: FontWeight.w700,
          // ),
          hintText: 'Place Holder',
        ),
      ),
    );
  }
}
