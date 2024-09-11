import 'package:dotted_border/dotted_border.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadCard extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const UploadCard({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 170.w,
        height: 170.h,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(16.r),
          dashPattern: const [6, 6],
          color: Palette.secondaryStroke,
          strokeWidth: 3.w,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: child,
          ),
        ),
      ),
    );
  }
}
