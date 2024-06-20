import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/widgets/checkbox.dart';

class CheckboxQuestionModel extends BaseQuestion {
  final List<CheckboxData> options;
  final String? paragraph;
  final String questionText;
  final Function(List<CheckboxData>) onChanged;
  CheckboxQuestionModel({
    required this.onChanged,
    required this.questionText,
    required this.options,
    this.paragraph,
    required super.answer,
  }) : super(
          questionTextInEnglish: questionText,
          questionTextInArabic: questionText,
          imageUrl: "",
          voiceUrl: "",
        );
}
