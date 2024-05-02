import 'dart:math';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/grammar/components/drag_and_drop_question.dart';
import 'package:ez_english/features/sections/writing/components/multiple_choice_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GrammarPractice extends StatefulWidget {
  const GrammarPractice({super.key});

  @override
  State<GrammarPractice> createState() => _GrammarPracticeState();
}

class _GrammarPracticeState extends State<GrammarPractice> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    });
  }

  EvaluationState answerState = EvaluationState.empty;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "Grammar Practice",
            style:
                TextStyles.titleTextStyle.copyWith(color: Palette.primaryText),
          ),
          subtitle: Text(
            "Daily Conversations",
            style: TextStyles.subtitleTextStyle
                .copyWith(color: Palette.primaryText),
          ),
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [DragAndDropQuestion()],
                ),
              ),
            ),
          ),
          EvaluateAnswer(
            state: answerState,
            onPressed: () {
              print("Continuing");
            },
          )
        ],
      ),
    );
  }
}
