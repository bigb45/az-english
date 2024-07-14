import 'package:ez_english/features/home/content/data_entry_forms/radio_group_form.dart';
import 'package:flutter/material.dart';

class MultipleChoiceForm extends StatefulWidget {
  MultipleChoiceForm({super.key});

  @override
  State<MultipleChoiceForm> createState() => _MultipleChoiceFormState();
}

class _MultipleChoiceFormState extends State<MultipleChoiceForm> {
  int answerCount = 1;
  int maxAnswers = 5;
  List<RadioItemData> answers = [];
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        TextFormField(
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Question",
            hintText: "Enter the question",
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RadioGroupForm(
            onChanged: (newSelection) {
              print("set correct answer to ${newSelection.title}");
            },
            onAnswerUpdated: (newAnswer, option) {
              answers[0] = RadioItemData(title: newAnswer, value: option.value);
              print("updating answer ${option.title} to $newAnswer");
            },
            onDeleteItem: (deletedAnswer) {
              print("deleting answer ${deletedAnswer.value}");
            },
            options: List.generate(
              answers.length,
              (index) {
                return answers[index];
              },
            ),
            selectedOption: null),
        ElevatedButton(
          onPressed: () {
            if (answerCount < maxAnswers) {
              setState(() {
                answers.add(
                  RadioItemData(
                    title: "",
                    value: "",
                  ),
                );
              });
            }
          },
          child: const Text(
            "Add answer",
          ),
        )
      ],
    ));
  }
}

Widget multipleChoiceAnswer() {
  return Container(
    child: TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Answer",
        hintText: "Enter the answer",
      ),
    ),
  );
}
