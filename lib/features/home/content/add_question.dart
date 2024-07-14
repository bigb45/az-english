import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  QuestionType? selectedQuestionType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "Add Question",
            style: TextStyles.titleTextStyle,
          ),
          subtitle: Text(
            "Add new questions",
            style: TextStyles.subtitleTextStyle,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: "A1",
                        child: Text("A1"),
                      ),
                      DropdownMenuItem(
                        value: "A2",
                        child: Text("A2"),
                      ),
                      DropdownMenuItem(
                        value: "B1",
                        child: Text("B1"),
                      ),
                      DropdownMenuItem(
                        value: "B2",
                        child: Text("B2"),
                      ),
                      DropdownMenuItem(
                        value: "C1",
                        child: Text("C1"),
                      ),
                      DropdownMenuItem(
                        value: "C2",
                        child: Text("C2"),
                      ),
                    ],
                    onChanged: (levelSelection) {
                      print("Level selected: $levelSelection");
                    },
                    decoration: const InputDecoration(
                      labelText: "Select level",
                      hintText: "Select level",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: "reading",
                        child: Text("Reading"),
                      ),
                      DropdownMenuItem(
                        value: "writing",
                        child: Text("Writing & Listening"),
                      ),
                      DropdownMenuItem(
                        value: "vocabulary",
                        child: Text("Vocabulary"),
                      ),
                      DropdownMenuItem(
                        value: "grammar",
                        child: Text("Grammar"),
                      ),
                    ],
                    onChanged: (sectionSelection) {
                      print("Section selected: $sectionSelection");
                    },
                    decoration: const InputDecoration(
                      labelText: "Section",
                      hintText: "Select section",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(
                  value: QuestionType.multipleChoice,
                  child: Text("Multiple Choice"),
                ),
                DropdownMenuItem(
                  value: QuestionType.checkbox,
                  child: Text("Multiple Select"),
                ),
                DropdownMenuItem(
                  value: QuestionType.dictation,
                  child: Text("Dictation"),
                ),
                DropdownMenuItem(
                  value: QuestionType.speaking,
                  child: Text("Speaking"),
                ),
                DropdownMenuItem(
                  value: QuestionType.passage,
                  child: Text("Passage"),
                ),
                DropdownMenuItem(
                  value: QuestionType.youtubeLesson,
                  child: Text("Youtube video"),
                ),
                DropdownMenuItem(
                  value: QuestionType.vocabulary,
                  child: Text("Vocabulary"),
                ),
                DropdownMenuItem(
                  value: QuestionType.fillTheBlanks,
                  child: Text("Fill in the blank"),
                ),
                DropdownMenuItem(
                  value: QuestionType.sentenceForming,
                  child: Text("Sentence forming"),
                ),
                DropdownMenuItem(
                  value: QuestionType.findWordsFromPassage,
                  child: Text("Find words from passage"),
                ),
                DropdownMenuItem(
                  value: QuestionType.answerQuestionsFromPassage,
                  child: Text("Answer questions from passage"),
                ),
              ],
              onChanged: (questionTypeSelection) {
                print(
                    "Question type selected: ${questionTypeSelection!.toShortString()}");
                setState(() {
                  selectedQuestionType = questionTypeSelection;
                });
              },
              decoration: const InputDecoration(
                labelText: "Question Type",
                hintText: "Select question type",
                border: OutlineInputBorder(),
              ),
            ),
            selectedQuestionType == null
                ? const Text("select question type to start")
                : SizedBox(
                    child:
                        Text("Selected question type: $selectedQuestionType"),
                  )
          ],
        ),
      ),
    );
  }
}
