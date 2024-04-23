import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  const CustomTextField(
      {super.key, required this.controller, this.focusNode, this.hintText});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      enabled: true,
      style: TextStyle(
        color: Palette.primaryText,
        fontFamily: 'Inter',
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Palette.secondaryStroke,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Palette.error,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Palette.secondaryVariantStroke,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: Palette.secondaryText,
          fontFamily: 'Inter',
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        hintText: widget.hintText ?? "Enter text",
      ),
    );
  }
}
