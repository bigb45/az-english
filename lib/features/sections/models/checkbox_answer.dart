// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/widgets/checkbox.dart';

class CheckboxAnswer extends BaseAnswer<List<CheckboxData>> {
  CheckboxAnswer({
    required super.answer,
  }) : super(answerType: AnswerType.checkbox);
  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap

    throw UnimplementedError();
  }

  @override
  bool validate(BaseAnswer? userAnswer) {
    Set<String>? correctAnswerTitles =
        answer?.map((e) => e.title).toSet() ?? {};

    if (userAnswer?.answer.isEmpty) {
      return false;
    }

    List<dynamic> validationResult = userAnswer?.answer!.map((answer) {
      bool isCorrect = correctAnswerTitles.contains(answer.title);

      return isCorrect;
    }).toList();

    return validationResult.every((element) => element == true);
  }
}
