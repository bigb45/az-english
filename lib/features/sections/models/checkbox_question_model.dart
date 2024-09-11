import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/widgets/checkbox.dart';

// TODO: implement toMap
class CheckboxQuestionModel extends BaseQuestion<List<CheckboxData>> {
  final List<CheckboxData> options;
  final String? paragraph;
  final String questionText;
  CheckboxQuestionModel({
    required this.questionText,
    required this.options,
    this.paragraph,
    required super.answer,
  }) : super(
          questionTextInEnglish: questionText,
          questionTextInArabic: questionText,
          imageUrl: "",
          voiceUrl: "",
          questionType: QuestionType.checkbox,
          titleInEnglish: null,
        );

  // TODO: make sure toMap implementation is correct
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'options': options.map((option) => option.toMap()).toList(),
    };
  }

  @override
  bool evaluateAnswer() {
    return answer?.validate(userAnswer) ?? false;
  }

  @override
  BaseQuestion<List<CheckboxData>> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }
}
