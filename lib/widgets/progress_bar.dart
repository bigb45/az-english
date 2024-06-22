import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBar extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double value;
  const ProgressBar(
      {super.key, required this.value, this.minValue = 0, this.maxValue = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.h,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  color: Palette.blackColor.withOpacity(0.25),
                  blurRadius: 4,
                ),
              ],
              color: Palette.secondaryStroke,
              borderRadius: BorderRadius.circular(100),
            ),
            height: 23.h,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              double percentage = (value - minValue) / (maxValue - minValue);
              double progressBarWidth = constraints.maxWidth * percentage;
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, 0),
                      color: Palette.blackColor.withOpacity(0.25),
                      blurRadius: 4,
                    ),
                  ],
                  color: Palette.tertiary,
                  borderRadius: BorderRadius.circular(100),
                ),
                width: progressBarWidth,
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 12.h),
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Palette.onTertiary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }
}
