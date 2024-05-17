import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final int maxLines;
  final bool isFocused;
  final String? Function(String?)? validator;
  final bool? isPasswordField;
  final TextFieldType? fieldType;
  const CustomTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.maxLines = 1,
    this.isFocused = false,
    this.validator,
    this.isPasswordField,
    this.fieldType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? _isFocused;
  @override
  void initState() {
    _isFocused = widget.isFocused;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          _isFocused = value;
        });
      },
      child: TextFormField(
        // TODO
        autovalidateMode: AutovalidateMode.disabled,
        validator: widget.validator,
        maxLines: widget.maxLines,
        textInputAction: TextInputAction.next,
        focusNode: widget.focusNode,
        obscureText: widget.fieldType == TextFieldType.password,
        controller: widget.controller,
        keyboardType: switch (widget.fieldType) {
          null => null,
          TextFieldType.phone => TextInputType.phone,
          TextFieldType.text => TextInputType.text,
          TextFieldType.password => TextInputType.text,
          TextFieldType.email => TextInputType.emailAddress,
        },
        enabled: true,
        style: TextStyle(
          color: Palette.primaryText,
          fontFamily: 'Inter',
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          filled: _isFocused! ? false : true,
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
      ),
    );
  }
}

enum TextFieldType {
  text,
  password,
  phone,
  email,
}
