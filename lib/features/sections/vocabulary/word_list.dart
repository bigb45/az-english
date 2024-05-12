import 'package:ez_english/features/sections/vocabulary/word_view.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/features/sections/vocabulary/components/word_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordListView extends StatelessWidget {
  final List<WordModel> words;
  final String pageTitle;
  final String pageSubtitle;
  const WordListView(
      {super.key,
      required this.words,
      this.pageTitle = "Vocabulary",
      this.pageSubtitle = "Daily Conversations"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            for (var word in words)
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
                          wordData: const WordDefinition(
                              "to look at or inspect.",
                              [
                                "the public can view the famous hall with its unique staircase",
                                // "Viewing the exhibit was a great experience",
                                // "I have viewed the document and it looks good",
                                // "Outsiders are not allowed to view the computers",
                              ],
                              "View, Viewed, Viewed",
                              word: "View",
                              type: WordType.verb),
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

class WordModel {
  final String word;
  final WordType type;
  final bool isNew;
  const WordModel({
    required this.word,
    required this.type,
    required this.isNew,
  });
}
