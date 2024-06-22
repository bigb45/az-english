import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/word_list_tile.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/vocabulary/viewmodel/vocabulary_section_viewmodel.dart';
import 'package:ez_english/features/sections/vocabulary/word_view.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WordsListView extends StatelessWidget {
  final String pageTitle;
  final String pageSubtitle;
  const WordsListView(
      {super.key,
      this.pageTitle = "Vocabulary",
      this.pageSubtitle = "Daily Conversations"});

  @override
  Widget build(BuildContext context) {
    final viewmodel =
        Provider.of<VocabularySectionViewmodel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Palette.primaryText),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
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
        child: Column(
          children: [
            for (var word in viewmodel.words)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                child: WordListTile(
                  word: word.word,
                  type: word.type,
                  isNew: word.isNew,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordView(
                          pageTitle: pageTitle,
                          pageSubtitle: pageSubtitle,
                          // TODO: pass actual word definition & examples from data model
                          wordData: WordDefinition(
                            word: "View",
                            type: WordType.verb,
                            definition: "to look at or inspect.",
                            exampleUsage: [
                              "the public can view the famous hall with its unique staircase",
                              // "Viewing the exhibit was a great experience",
                              // "I have viewed the document and it looks good",
                              // "Outsiders are not allowed to view the computers",
                            ],
                            tenses: "View, Viewed, Viewed",
                            questionTextInEnglish: '',
                            questionTextInArabic: '',
                            questionType: QuestionType.vocabulary,
                            imageUrl: '',
                            voiceUrl: '',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
