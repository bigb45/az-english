import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/finished_questions_screen.dart';
import 'package:ez_english/features/sections/components/word_list_tile.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/vocabulary/viewmodel/vocabulary_section_viewmodel.dart';
import 'package:ez_english/features/sections/vocabulary/word_view.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WordsListView extends StatefulWidget {
  final String pageTitle;
  final String pageSubtitle;
  const WordsListView(
      {super.key,
      this.pageTitle = "Vocabulary",
      this.pageSubtitle = "Daily Conversations"});

  @override
  State<WordsListView> createState() => _WordsListViewState();
}

class _WordsListViewState extends State<WordsListView> {
  bool finishedAllVocab = false;
  bool _checkAllWordsStatus(VocabularySectionViewmodel viewmodel) {
    if (viewmodel.areAllWordsNotNew()) {
      viewmodel.updateUserProgress();
      return true;
    }
    return false;
  }

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
        if (finishedAllVocab) {
          return FinishedQuestionsScreen(
            onFinished: () async {
              await viewmodel.updateUserProgress().then((value) {
                context.pop();
                context.pop();
                context.pop();
              });
            },
          );
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (canPop) {},
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Palette.primaryText,
                  ),
                  onPressed: () async {
                    await viewmodel.updateSectionProgress();
                    if (!context.mounted) return;
                    context.go('/');
                  },
                ),
              ],
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Palette.secondary,
              title: ListTile(
                contentPadding: const EdgeInsets.only(left: 0, right: 0),
                title: Text(
                  widget.pageTitle,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Palette.primaryText,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  widget.pageSubtitle,
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: Palette.primaryText,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressBar(value: viewmodel.progress!),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: viewmodel.questions.length,
                      itemBuilder: (context, index) {
                        var word = viewmodel.questions[index];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
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
                                                    pageTitle: widget.pageTitle,
                                                    pageSubtitle:
                                                        widget.pageSubtitle,
                                                    wordData: word),
                                              ),
                                            );
                                            viewmodel.updateWordStatus(word);
                                            viewmodel
                                                .updateInteractedQuestionsList(
                                                    index);
                                            finishedAllVocab =
                                                _checkAllWordsStatus(viewmodel);
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
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
