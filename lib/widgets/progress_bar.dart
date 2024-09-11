import 'dart:math';

import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBar extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double value;
  final Duration duration;
  final double? width;

  const ProgressBar({
    super.key,
    required this.value,
    this.width,
    this.minValue = 0,
    this.maxValue = 100,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: widget.minValue, end: widget.value)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(_controller);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23.h,
      width: widget.width,
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
              borderRadius: BorderRadius.circular(100.r),
            ),
            height: 23.h,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              double percentage = (_animation.value - widget.minValue) /
                  (widget.maxValue - widget.minValue);
              percentage = max(0.1, percentage);
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
                  borderRadius: BorderRadius.circular(100.r),
                ),
                width: progressBarWidth,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 12.h),
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Palette.onTertiary,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
