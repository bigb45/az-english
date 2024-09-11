import 'package:ez_english/features/models/test_result.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestResultCard extends StatelessWidget {
  final TestResult result;
  final VoidCallback onTap;
  const TestResultCard({super.key, required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        // onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Palette.secondaryStroke),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: ScreenUtil().screenWidth * 0.5),
                          child: Text(
                            result.examDate,
                            style: TextStyles.practiceCardSecondaryText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        const Icon(
                          Icons.circle,
                          color: Palette.primaryText,
                          size: 5,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "${result.examScore}%",
                          style: TextStyles.wordType,
                        ),
                        SizedBox(width: 10.w),
                        const Icon(
                          Icons.circle,
                          color: Palette.primaryText,
                          size: 5,
                        ),
                        SizedBox(width: 10.w),
                        result.examStatus == ExamStatus.passed
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                        SizedBox(width: 10.w),
                        result.examStatus == ExamStatus.passed
                            ? Text(
                                "Passed",
                                style: TextStyles.wordType.copyWith(
                                  color: Palette.primary,
                                  fontSize: 16.sp,
                                ),
                              )
                            : Text(
                                "Failed",
                                style: TextStyles.wordType.copyWith(
                                  color: Palette.error,
                                  fontSize: 16.sp,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
