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
    return Consumer<VocabularySectionViewmodel>(
      builder: (context, viewmodel, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewmodel.error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text(
                      viewmodel.error?.message ?? "An error occurred",
                    ),
                  ),
                )
                .closed
                .then((reason) => viewmodel.resetError());
          }
        });
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
                for (var word in viewmodel.questions)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5),
                    child: Builder(
                      builder: (context) {
                        switch (word?.questionType) {
                          case QuestionType.vocabulary:
                            return WordListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WordView(
                                        pageTitle: pageTitle,
                                        pageSubtitle: pageSubtitle,
                                        wordData: word),
                                  ),
                                );
                              },
                              word: word as WordDefinition,
                            );
                          default:
                            return Text(
                                "Unsupported Question Type ${word?.questionType}");
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
