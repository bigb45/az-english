abstract class BaseQuestion<T> {
  String questionText;
  String imageUrl;
  String voiceUrl;
  QuestionType? questionType;
  BaseQuestion({
    required this.questionText,
    required this.imageUrl,
    required this.voiceUrl,
    this.questionType,
  });

  Map<String, dynamic> toMap();

  factory BaseQuestion.fromMap(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson not implemented');
  }
}

enum QuestionType {
  multipleChoice,
  dictation,
  speaking,
}
