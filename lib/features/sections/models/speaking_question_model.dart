import 'package:ez_english/features/models/base_question.dart';

class SpeakingQuestionModel extends BaseQuestion<String> {
  String question;
  String? audioUrl;
  final String correctAnswer;
  SpeakingQuestionModel(
      {required this.question, required this.correctAnswer, this.audioUrl})
      : super(
            questionTextInEnglish: question,
            questionTextInArabic: question,
            answer: correctAnswer,
            imageUrl: '',
            voiceUrl: audioUrl ?? "",
            questionType: QuestionType.speaking);

  // factory SpeakingQuestionModel.fromJson(Map<String, dynamic> json) {
  //   return SpeakingQuestionModel(
  //       question: json['question'],
  //       correctAnswer: json['answer'],
  //       audioUrl: json['audioUrl']);
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'question': question,
  //     'answer': correctAnswer,
  //     'audioUrl': audioUrl
  //   };
  // }
}
