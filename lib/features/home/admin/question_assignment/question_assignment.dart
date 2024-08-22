import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionAssignment extends StatelessWidget {
  final String userId;
  const QuestionAssignment({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(items: const [
                DropdownMenuItem(
                  value: "mcq",
                  child: Text("mcq"),
                ),
                DropdownMenuItem(
                  value: "child",
                  child: Text("child"),
                )
              ], hint: const Text("Question type"), onChanged: (value) {}),
              DropdownButton<QuestionType>(
                  items: const [],
                  hint: const Text("Question section"),
                  onChanged: (value) {})
            ],
          )
        ],
      ),
    );
  }
}
