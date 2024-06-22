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

  @override
  bool validate(BaseAnswer? userAnswer) {
    // TODO: implement validate
    throw UnimplementedError();
  }
}
