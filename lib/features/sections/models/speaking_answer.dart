import 'package:ez_english/features/models/base_answer.dart';

class SpeakingAnswer extends BaseAnswer<int> {
  SpeakingAnswer({
    required int answer,
  }) : super(answerType: AnswerType.speakingScore, answer: answer);

  @override
  SpeakingAnswer copy() {
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
    };
  }

  @override
  bool? validate(BaseAnswer? userAnswer) {
    try {
      return (userAnswer as SpeakingAnswer).answer! > answer!;
    } catch (e) {
      return false;
    }
  }
}
