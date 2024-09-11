import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';

class SentenceFormingQuestionModel extends BaseQuestion<String> {
  final String words;
  final String correctAnswer;
  final String question;
  final String? partialSentence = null;
  SentenceFormingQuestionModel({
    required this.question,
    required this.words,
    required this.correctAnswer,
  }) : super(
            questionTextInEnglish: question,
            titleInEnglish: null,
            questionTextInArabic: question,
            imageUrl: '',
            voiceUrl: '',
            questionType: QuestionType.sentenceForming,
            answer: StringAnswer(answer: correctAnswer));

  @override
  BaseQuestion<String> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }
}
