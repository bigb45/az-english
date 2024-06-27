import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/widgets/checkbox.dart';

class CheckboxAnswer extends BaseAnswer<List<CheckboxData>> {
  CheckboxAnswer({
    required List<CheckboxData> answer,
  }) : super(answerType: AnswerType.checkbox);
  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

// TODO: implement this such that it returns a list of checkbox data marking the incorrect answers if they exist
// TODO: change parameter type to List<BaseAnswer>
  @override
  bool validate(BaseAnswer? userAnswer) {
    print("validating checkbox answer: $userAnswer, $answer");
    return userAnswer?.answer != null &&
        userAnswer is CheckboxAnswer &&
        userAnswer.answer?.length == answer?.length &&
        userAnswer.answer!.every((element) => answer!.contains(element));
  }
}
