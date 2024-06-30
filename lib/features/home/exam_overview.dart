import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/models/exam_result.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamOverview extends StatelessWidget {
  final ExamResult result;
  const ExamOverview({super.key, required this.result});

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w, vertical: Constants.padding20),
              child: Text("Reading:", style: TextStyles.bodyLarge),
            ),
            Center(
              child: ResultCard(
                topText: "GOOD",
                score: Score.good,
                mainText: "8/10 ANSWERED CORRECTLY",
                result: result,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w, vertical: Constants.padding20),
              child: Text("Writing & Listening:", style: TextStyles.bodyLarge),
            ),
            Center(
              child: ResultCard(
                topText: "BAD",
                score: Score.bad,
                mainText: "2/10 ANSWERED CORRECTLY",
                result: result,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w, vertical: Constants.padding20),
              child: Text("Grammar:", style: TextStyles.bodyLarge),
            ),
            Center(
              child: ResultCard(
                topText: "GOOD",
                score: Score.good,
                mainText: "7/10 ANSWERED CORRECTLY",
                result: result,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w, vertical: Constants.padding20),
              child: Text("Final grade:", style: TextStyles.bodyLarge),
            ),
            Center(
              child: ResultCard(
                topText: "AVERAGE",
                score: Score.average,
                mainText: "19/30 ANSWERED CORRECTLY",
                result: result,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
