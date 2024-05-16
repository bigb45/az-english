import 'dart:math';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/reading/components/multiple-choice%20question.dart';
import 'package:ez_english/features/sections/reading/components/speaking_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:go_router/go_router.dart';

class ReadingPractice extends StatefulWidget {
  const ReadingPractice({super.key});

  @override
  State<ReadingPractice> createState() => _ReadingPracticeState();
}

class _ReadingPracticeState extends State<ReadingPractice> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Palette.secondary);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Palette.primaryText,
        //   ),
        //   onPressed: () {
        //     // use this to avoid returning to the root screen because of android behavior
        //     Routemaster.of(context).history.back();
        //   },
        // ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Palette.primaryText,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return leavePracticeAlertDialog(onConfirm: () {
                    Navigator.pop(dialogContext);
                    // this pops the whole stack and navigates back to the home screen
                    context.go('/');
                  }, onCancel: () {
                    Navigator.pop(dialogContext);
                  });
                },
              );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Palette.secondary,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            AppStrings.readingSectionPracticeAppbarTitle,
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.primaryText,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          // TODO change it to dymaic string from the API
          subtitle: Text(
            "Daily Conversations",
            style: TextStyle(
              fontSize: 17.sp,
              color: Palette.primaryText,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: const Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ProgressBar(value: 20),
                    ),
                    SpeakingQuestion(),
                  ],
                ),
              ),
            ),
          ),
          EvaluateAnswer()
        ],
      ),
    );
  }
}

class EvaluateAnswer extends StatefulWidget {
  const EvaluateAnswer({super.key});

  @override
  State<EvaluateAnswer> createState() => _EvaluateAnswerState();
}

class _EvaluateAnswerState extends State<EvaluateAnswer> {
  EvaluationState evaulationState = EvaluationState.empty;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: switch (evaulationState) {
        EvaluationState.correct => Palette.primaryFill,
        EvaluationState.incorrect => Palette.errorFill,
        _ => Palette.secondary,
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Constants.padding8, horizontal: Constants.padding8),
        child: Button(
            onPressed: () {
              setState(() {
                evaulationState = Random().nextBool()
                    ? EvaluationState.correct
                    : EvaluationState.incorrect;
              });
            },
            type: switch (evaulationState) {
              EvaluationState.correct => ButtonType.primary,
              EvaluationState.incorrect => ButtonType.error,
              _ => ButtonType.primaryVariant,
            },
            text: "check"),
      ),
    );
  }
}

// TODO: move this to separate file
enum EvaluationState {
  correct,
  incorrect,
  empty,
}
