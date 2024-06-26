import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/utils/utils.dart';

class StringAnswer extends BaseAnswer<String> {
  StringAnswer({
    required super.answer,
  }) : super(
          answerType: AnswerType.string,
        );

  @override
  bool validate(BaseAnswer? userAnswer) {
    // TODO: compare answers here and return true or false
    // might change return type to AnswerValidationResult
    print("validating String answer, ${userAnswer?.answer}, $answer");
    return answer != null &&
        (userAnswer as StringAnswer).answer?.normalize() == answer?.normalize();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
    };
  }
}
