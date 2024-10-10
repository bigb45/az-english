import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinishedQuestionsScreen extends StatelessWidget {
  final VoidCallback onFinished;
  const FinishedQuestionsScreen({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: ListTile(
            title: Text(
              "Finished all questions",
              style: TextStyles.titleTextStyle,
            ),
            contentPadding: const EdgeInsets.only(left: 0, right: 0),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(Constants.padding20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "You finished all the practice question, proceed to the next section.",
                    style: TextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Button(onPressed: onFinished, text: "finish"),
            ],
          ),
        ),
      ),
    );
  }
}
