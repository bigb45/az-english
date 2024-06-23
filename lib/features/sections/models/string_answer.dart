import 'package:ez_english/features/models/base_answer.dart';

class StringAnswer extends BaseAnswer<String> {
  StringAnswer({
    String? answer,
  }) : super(answerType: AnswerType.string, answer: answer);

  @override
  bool validate(BaseAnswer? userAnswer) {
    // TODO: compare answers here and return true or false
    // might change return type to AnswerValidationResult
    return false;
  }
}
