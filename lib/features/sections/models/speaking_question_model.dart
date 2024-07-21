import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';

class SpeakingQuestionModel extends BaseQuestion<String> {
  String question;
  String? audioUrl;
  final String correctAnswer;
  SpeakingQuestionModel(
      {required this.question, required this.correctAnswer, this.audioUrl})
      : super(
            titleInEnglish: null,
            questionTextInEnglish: question,
            questionTextInArabic: question,
            answer: StringAnswer(answer: correctAnswer),
            imageUrl: '',
            voiceUrl: audioUrl ?? "",
            questionType: QuestionType.speaking);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SpeakingQuestionModel) return false;

    return other.runtimeType == runtimeType &&
        other.question == question &&
        other.audioUrl == audioUrl &&
        other.correctAnswer == correctAnswer &&
        other.questionTextInEnglish ==
            questionTextInEnglish && // From BaseQuestion
        other.questionTextInArabic ==
            questionTextInArabic && // From BaseQuestion
        other.imageUrl == imageUrl && // From BaseQuestion
        other.voiceUrl == voiceUrl && // From BaseQuestion
        other.titleInEnglish == titleInEnglish && // From BaseQuestion
        other.questionType == questionType; // From BaseQuestion
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        question,
        audioUrl,
        correctAnswer,
        questionTextInEnglish, // From BaseQuestion
        questionTextInArabic, // From BaseQuestion
        imageUrl, // From BaseQuestion
        voiceUrl, // From BaseQuestion
        titleInEnglish, // From BaseQuestion
        questionType, // From BaseQuestion
      );

  @override
  BaseQuestion<String> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }

// TODO: make sure this is correct
  // factory SpeakingQuestionModel.fromJson(Map<String, dynamic> json) {
  //   return SpeakingQuestionModel(
  //       question: json['question'],
  //       correctAnswer: json['answer'],
  //       audioUrl: json['audioUrl']);
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'question': question,
  //     'answer': correctAnswer,
  //     'audioUrl': audioUrl
  //   };
  // }
}
