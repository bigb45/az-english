import 'package:ez_english/features/models/test_result.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestOverview extends StatelessWidget {
  final TestResult result;
  const TestOverview({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "${result.examName} overview",
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "Exam on ${result.examDate}",
            style: TextStyle(
              fontSize: 17.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: Center(
        child: Wrap(
          runSpacing: 10.w,
          spacing: 10.w,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text("Reading:", style: TextStyles.bodyLarge),
                ResultCard(
                  topText: "GOOD",
                  score: Score.good,
                  mainText: "8/10 ANSWERED CORRECTLY",
                  result: result,
                ),
              ],
            ),
            Column(
              children: [
                Text("Writing & Listening:", style: TextStyles.bodyLarge),
                ResultCard(
                  topText: "BAD",
                  score: Score.bad,
                  mainText: "2/10 ANSWERED CORRECTLY",
                  result: result,
                ),
              ],
            ),
            Column(
              children: [
                Text("Grammar:", style: TextStyles.bodyLarge),
                ResultCard(
                  topText: "GOOD",
                  score: Score.good,
                  mainText: "7/10 ANSWERED CORRECTLY",
                  result: result,
                ),
              ],
            ),
            Column(
              children: [
                Text("Final grade:", style: TextStyles.bodyLarge),
                ResultCard(
                  topText: "AVERAGE",
                  score: Score.average,
                  mainText: "19/30 ANSWERED CORRECTLY",
                  result: result,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
