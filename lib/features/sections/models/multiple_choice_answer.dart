import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/widgets/radio_button.dart';

class MultipleChoiceAnswer extends BaseAnswer<RadioItemData> {
  MultipleChoiceAnswer({
    required RadioItemData answer,
  }) : super(answerType: AnswerType.multipleChoice, answer: answer);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'answer': answer!.toMap(), // Call the toMap method of RadioItemData
    };
  }

  @override
  bool validate(BaseAnswer? userAnswer) {
    return userAnswer?.answer.value == answer?.value && userAnswer != null;
  }
}
