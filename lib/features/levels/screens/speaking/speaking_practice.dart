import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';

class SpeakingPractice extends StatefulWidget {
  const SpeakingPractice({super.key});

  @override
  State<SpeakingPractice> createState() => _SpeakingPracticeState();
}

class _SpeakingPracticeState extends State<SpeakingPractice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            AppStrings.speakingPracticeScreenTitle,
            style: TextStyles.titleTextStyle,
          ),
          subtitle: Text(
            "Speaking Practice",
            style: TextStyles.subtitleTextStyle,
          ),
        ),
      ),
      body: Placeholder(),
    );
  }
}
