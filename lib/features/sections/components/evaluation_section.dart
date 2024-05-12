import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvaluateAnswer extends StatefulWidget {
  final VoidCallback onPressed;
  final EvaluationState state;
  const EvaluateAnswer(
      {super.key, required this.onPressed, this.state = EvaluationState.empty});

  @override
  State<EvaluateAnswer> createState() => _EvaluateAnswerState();
}

class _EvaluateAnswerState extends State<EvaluateAnswer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130.h,
      color: switch (widget.state) {
        EvaluationState.correct => Palette.primaryFill,
        EvaluationState.incorrect => Palette.errorFill,
        _ => Palette.secondary,
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Constants.padding8, horizontal: Constants.padding12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                switch (widget.state) {
                  EvaluationState.correct => "Good Job!",
                  EvaluationState.incorrect => "Try Again!",
                  _ => "",
                },
                style: TextStyles.bodyLarge.copyWith(
                    color: switch (widget.state) {
                  EvaluationState.correct => Palette.primary,
                  EvaluationState.incorrect => Palette.error,
                  _ => Palette.secondary,
                })),
            Button(
              onPressed: () {
                widget.onPressed();

                // setState(() {
                //   evaulationState = Random().nextBool()
                //       ? EvaluationState.correct
                //       : EvaluationState.incorrect;
                // });
              },
              type: switch (widget.state) {
                EvaluationState.correct => ButtonType.primary,
                EvaluationState.incorrect => ButtonType.error,
                _ => ButtonType.primaryVariant,
              },
              text: switch (widget.state) {
                EvaluationState.empty => "check",
                _ => "continue",
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum EvaluationState {
  correct,
  incorrect,
  empty,
}
