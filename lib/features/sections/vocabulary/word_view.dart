import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/vocabulary/components/word_list_tile.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
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
                    style: TextStyles.practiceCardSecondaryText.copyWith(
                      color: Palette.primaryText,
                      fontSize: 24.sp,
                    )),
              ),
              Card(
                color: Palette.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Palette.secondaryStroke, width: 1),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wordData.word,
                        style: TextStyles.vocabularyTerm.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        type == WordType.noun ? "Noun" : "Verb",
                        style: TextStyles.wordType.copyWith(
                          fontSize: 20.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        wordData.definition,
                        style: TextStyles.practiceCardSecondaryText.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Palette.secondaryStroke, width: 1),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Examples",
                        style: TextStyles.practiceCardSecondaryText.copyWith(
                          color: Palette.primaryText,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ...List.generate(
                        wordData.exampleUsage?.length ?? 0,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Text(
                              "\"${wordData.exampleUsage![index]}\"",
                              textAlign: TextAlign.left,
                              style: TextStyles.vocabularyExample.copyWith(
                                color: Palette.primaryText,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Palette.secondaryStroke, width: 1),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding12),
                  child: Text(
                    wordData.tenses ?? "",
                    style: TextStyles.practiceCardSecondaryText.copyWith(
                      color: Palette.primaryText,
                    ),
                  ),
                ),
              ),
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
