import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/features/models/test_result.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultCard extends StatelessWidget {
  final String mainText;
  final String topText;
  final Score score;
  final TestResult result;
  const ResultCard(
      {super.key,
      required this.mainText,
      required this.topText,
      required this.result,
      this.score = Score.good});

  @override
  Widget build(BuildContext context) {
    var color = switch (score) {
      Score.good => Theme.of(context).primaryColor,
      Score.average => Palette.tertiary,
      Score.bad => Palette.error,
    };
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(Constants.padding2),
          child: Text(topText,
              style: TextStyle(
                color: Palette.secondary,
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              )),
        ),
        Padding(
          padding: EdgeInsets.all(Constants.padding2),
          child: Container(
            width: 180.w,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(Constants.padding30),
              child: Center(
                child: Text(
                  mainText,
                  style: TextStyle(
                      color: color,
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

enum Score { good, average, bad }
