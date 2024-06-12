import 'package:ez_english/features/models/base_question.dart';

class GrammarQuestionModel extends BaseQuestion {
  GrammarQuestionModel({
    required this.question,
    required this.words,
    required this.correctAnswer,
    required super.questionType,
    this.youtubeUrl,
  }) : super(
          questionTextInEnglish: "",
          questionTextInArabic: "",
          imageUrl: "",
          voiceUrl: "",
        );

  final String question;
  final String words;
  final String correctAnswer;
  final String? youtubeUrl;
}
