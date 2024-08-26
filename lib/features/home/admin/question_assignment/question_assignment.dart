import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/question_assignment/question_assignment_viewmodel.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuestionAssignment extends StatefulWidget {
  final String userId;

  const QuestionAssignment({super.key, required this.userId});

  @override
  State<QuestionAssignment> createState() => _QuestionAssignmentState();
}

class _QuestionAssignmentState extends State<QuestionAssignment> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewmodel =
          Provider.of<QuestionAssignmentViewmodel>(context, listen: false);
      viewmodel.setValuesAndInit(
        userId: widget.userId,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionAssignmentViewmodel>(
      builder: (context, viewmodel, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              viewmodel.reset();
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
            color: Palette.primaryText,
          ),
          title: const Text(
            'User Settings',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(Constants.padding12),
          child: Column(
            children: [
              CustomTextField(
                controller: _searchController,
                hintText: "Search questions",
                onChanged: (String query) {
                  viewmodel.updateAndFilter(query: query);
                },
                textInputAction: TextInputAction.search,
                trailingIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    viewmodel.updateAndFilter(query: _searchController.text);
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // question type selector
                  Expanded(
                    child: DropdownButton<QuestionType>(
                      value: viewmodel.selectedQuestionType,
                      items: const [
                        DropdownMenuItem(
                          value: QuestionType.multipleChoice,
                          child: Text("Multiple Choice"),
                        ),
                        DropdownMenuItem(
                          value: QuestionType.dictation,
                          child: Text("Dictation"),
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
                      ],
                      hint: const Text("Question type"),
                      onChanged: (value) {
                        viewmodel.updateAndFilter(selectedQuestionType: value);
                      },
                    ),
                  ),

                  // question section selector
                  Expanded(
                    child: DropdownButton<String>(
                      value: viewmodel.selectedSection,
                      items: const [
                        DropdownMenuItem(
                          value: "reading",
                          child: Text("Reading"),
                        ),
                        DropdownMenuItem(
                          value: "listening",
                          child: Text("Listening"),
                        ),
                        DropdownMenuItem(
                          value: "writing",
                          child: Text("Writing"),
                        ),
                        DropdownMenuItem(
                          value: "vocabulary",
                          child: Text("Vocabulary"),
                        ),
                        DropdownMenuItem(
                          value: "grammar",
                          child: Text("Grammar"),
                        ),
                        DropdownMenuItem(
                          value: "speaking",
                          child: Text("Speaking"),
                        ),
                        DropdownMenuItem(
                          value: "test",
                          child: Text("Test"),
                        ),
                      ],
                      hint: const Text("Question section"),
                      onChanged: (value) {
                        viewmodel.updateAndFilter(selectedSection: value);
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                  child: viewmodel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewmodel.questions.isNotEmpty
                          ? ListView.builder(
                              itemCount: viewmodel.filteredQuestions.length,
                              itemBuilder: (context, index) {
                                BaseQuestion question =
                                    viewmodel.filteredQuestions[index];
                                bool isAssigned = viewmodel.assignedQuestions
                                    .contains(question);
                                return VerticalListItemCard(
                                  action: isAssigned ? Icons.delete : Icons.add,
                                  onIconPressed: () {
                                    isAssigned
                                        ? viewmodel.removeQuestion(question)
                                        : viewmodel.assignQuestion(question);
                                  },
                                  onTap: () {
                                    showPreviewModalSheet(
                                        title: "Question Preview",
                                        context: context,
                                        question:
                                            viewmodel.filteredQuestions[index],
                                        onSubmit: null,
                                        showSubmitButton: false);
                                  },
                                  showDeleteIcon: false,
                                  mainText:
                                      "${index + 1}. ${viewmodel.filteredQuestions[index].questionTextInEnglish ?? "No question text"}",
                                  info: Text(viewmodel.filteredQuestions[index]
                                          .titleInEnglish ??
                                      ""),
                                  subText: viewmodel
                                      .filteredQuestions[index].questionType
                                      .toShortString(),
                                );
                              },
                            )
                          : const Text(
                              "No questions found for the selected day."))
            ],
          ),
        ),
      ),
    );
  }
}
