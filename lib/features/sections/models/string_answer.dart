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
    return answer != null &&
        (userAnswer as StringAnswer).answer?.normalize() == answer?.normalize();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
    };
  }

  // Implementing == operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StringAnswer) return false;
    return other.answer == answer;
  }

  @override
  int get hashCode => answer.hashCode;

  @override
  StringAnswer copy() {
    return StringAnswer(
      answer: answer ?? '',
    )..userAnswer = userAnswer;
  }
}
