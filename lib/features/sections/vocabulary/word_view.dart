import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/features/sections/vocabulary/components/word_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordView extends StatelessWidget {
  final WordDefinition wordData;
  final String pageTitle;
  final String pageSubtitle;
  const WordView(
      {super.key,
      required this.wordData,
      this.pageTitle = "Vocabulary",
      this.pageSubtitle = "Daily Conversations"});

  @override
  Widget build(BuildContext context) {
    final type = wordData.type;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Palette.primaryText),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: Palette.primaryText,
        backgroundColor: Palette.secondary,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            pageTitle,
            style: TextStyles.titleTextStyle.copyWith(
              color: Palette.primaryText,
            ),
          ),
          subtitle: Text(
            pageSubtitle,
            style: TextStyles.subtitleTextStyle.copyWith(
              color: Palette.primaryText,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Constants.padding12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.padding30),
                child: Text("Word of the Day",
                    style: TextStyles.practiceCardSecondaryText),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wordData.word,
                    style: TextStyles.vocabularyTerm,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    switch (type) {
                      WordType.noun => "Noun",
                      WordType.verb => "Verb",
                    },
                    style: TextStyles.wordType.copyWith(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(wordData.definition,
                      style: TextStyles.practiceCardSecondaryText),
                ],
              ),
              SizedBox(height: 30.h),
              ...List.generate(
                wordData.exampleUsage?.length ?? 0,
                (index) {
                  return Wrap(
                    children: [
                      // const Expanded(child: SizedBox()),
                      Text(
                        "\"${wordData.exampleUsage![index]}\"",
                        textAlign: TextAlign.center,
                        style: TextStyles.vocabularyExample,
                      ),
                      // const Expanded(child: SizedBox()),
                    ],
                  );
                },
              ),
              SizedBox(height: 30.h),
              Text("${wordData.tenses}",
                  style: TextStyles.practiceCardSecondaryText)
            ],
          ),
        ),
      ),
    );
  }
}

class WordDefinition {
  final String word;
  final WordType type;
  final String definition;
  final List<String>? exampleUsage;
  final String? tenses;
  const WordDefinition(
    this.definition,
    this.exampleUsage,
    this.tenses, {
    required this.word,
    required this.type,
  });
}
