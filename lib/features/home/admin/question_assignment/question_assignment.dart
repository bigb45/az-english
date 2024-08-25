import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/question_assignment/question_assignment_viewmodel.dart';
import 'package:ez_english/features/home/admin/users_settings_viewmodel.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuestionAssignment extends StatefulWidget {
  final String userId;

  QuestionAssignment({super.key, required this.userId});

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
      final allUsersViewmodel =
          Provider.of<UsersSettingsViewmodel>(context, listen: false);
      viewmodel.setValuesAndInit(
        userId:
            allUsersViewmodel.filteredUsers[int.tryParse(widget.userId)!]!.id!,
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
                    child: DropdownButton<String>(
                      value: viewmodel.selectedQuestionType,
                      items: [
                        DropdownMenuItem(
                          value: "mcq",
                          child:
                              Text("mcq", style: TextStyles.wordChipTextStyle),
                        ),
                        DropdownMenuItem(
                          value: "child",
                          child: Text("child",
                              style: TextStyles.wordChipTextStyle),
                        )
                      ],
                      hint: Text("Question type",
                          style: TextStyles.wordChipTextStyle),
                      onChanged: (value) {
                        viewmodel.updateAndFilter(selectedQuestionType: value);
                      },
                    ),
                  ),

                  // question section selector
                  Expanded(
                    child: DropdownButton<String>(
                      value: viewmodel.selectedSection,
                      items: [
                        DropdownMenuItem(
                          value: "reading",
                          child: Text("reading",
                              style: TextStyles.wordChipTextStyle),
                        ),
                        DropdownMenuItem(
                          value: "writing",
                          child: Text("writing",
                              style: TextStyles.wordChipTextStyle),
                        ),
                        DropdownMenuItem(
                          value: "listening",
                          child: Text("listening",
                              style: TextStyles.wordChipTextStyle),
                        ),
                        DropdownMenuItem(
                          value: "speaking",
                          child: Text("speaking",
                              style: TextStyles.wordChipTextStyle),
                        ),
                      ],
                      hint: Text(
                        "Question section",
                        style: TextStyles.wordChipTextStyle,
                      ),
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
                                    viewmodel.questions[index];
                                bool isAssigned = viewmodel.assignedQuestions
                                    .contains(question);
                                BaseQuestion displayedQuestion = isAssigned
                                    ? viewmodel.assignedQuestions.firstWhere(
                                        (assignedQuestion) =>
                                            assignedQuestion == question)
                                    : question;

                                return VerticalListItemCard(
                                  action: isAssigned ? Icons.delete : Icons.add,
                                  onIconPressed: () {
                                    isAssigned
                                        ? viewmodel.removeQuestion(
                                            displayedQuestion, index)
                                        : viewmodel
                                            .assignQuestion(displayedQuestion);
                                  },
                                  onTap: () {
                                    showPreviewModalSheet(
                                        title: "Question Preview",
                                        context: context,
                                        question: viewmodel.questions[index],
                                        onSubmit: null,
                                        showSubmitButton: false);
                                  },
                                  showDeleteIcon: false,
                                  mainText:
                                      "${index + 1}. ${viewmodel.questions[index].questionTextInEnglish ?? "No question text"}",
                                  info: Text(viewmodel
                                          .questions[index].titleInEnglish ??
                                      ""),
                                  subText: viewmodel
                                      .questions[index].questionType
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
