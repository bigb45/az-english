import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvaluationSection extends StatefulWidget {
  final VoidCallback onPressed;
  final EvaluationState state;
  final VoidCallback? onContinue;
  const EvaluationSection(
      {super.key,
      required this.onPressed,
      this.state = EvaluationState.empty,
      this.onContinue});

  @override
  State<EvaluationSection> createState() => _EvaluationSectionState();
}

class _EvaluationSectionState extends State<EvaluationSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              onPressed: switch (widget.state) {
                EvaluationState.correct => widget.onContinue,
                EvaluationState.incorrect => widget.onPressed,
                EvaluationState.noState => widget.onContinue,
                EvaluationState.empty => widget.onPressed,
                // _ => widget.onPressed,
              },
              type: switch (widget.state) {
                EvaluationState.correct => ButtonType.primary,
                EvaluationState.incorrect => ButtonType.error,
                _ => ButtonType.primaryVariant,
              },
              text: switch (widget.state) {
                EvaluationState.empty => "check",
                EvaluationState.incorrect => "check",
                EvaluationState.correct => "continue",
                EvaluationState.noState => "next",
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
  noState,
  empty,
}
