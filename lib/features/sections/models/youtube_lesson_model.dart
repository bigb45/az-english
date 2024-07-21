import 'package:ez_english/features/models/base_question.dart';

class YoutubeLessonModel extends BaseQuestion {
  String? youtubeUrl;

  YoutubeLessonModel(
      {required this.youtubeUrl,
      super.questionType = QuestionType.youtubeLesson,
      super.voiceUrl,
      super.questionTextInEnglish,
      super.questionTextInArabic,
      super.imageUrl,
      required super.titleInEnglish});
  @override
  YoutubeLessonModel copy() {
    return YoutubeLessonModel(
        youtubeUrl: youtubeUrl,
        questionType: questionType,
        voiceUrl: voiceUrl,
        questionTextInEnglish: questionTextInEnglish,
        questionTextInArabic: questionTextInArabic,
        imageUrl: imageUrl,
        titleInEnglish: titleInEnglish);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      "youtubeUrl": youtubeUrl,
    };
  }

  factory YoutubeLessonModel.fromMap(Map<String, dynamic> map) {
    return YoutubeLessonModel(
      youtubeUrl: map['youtubeUrl'],
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      voiceUrl: map['voiceUrl'],
      imageUrl: map['imageUrl'],
      questionType: QuestionType.youtubeLesson,
      titleInEnglish: map["titleInEnglish"],
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is YoutubeLessonModel &&
        other.youtubeUrl == youtubeUrl &&
        other.questionTextInEnglish == questionTextInEnglish &&
        other.questionTextInArabic == questionTextInArabic &&
        other.voiceUrl == voiceUrl &&
        other.imageUrl == imageUrl &&
        other.titleInEnglish == titleInEnglish &&
        other.questionType == questionType;
  }

  @override
  int get hashCode => Object.hash(youtubeUrl, questionTextInEnglish,
      questionTextInArabic, voiceUrl, imageUrl, titleInEnglish, questionType);
  @override
  bool evaluateAnswer() {
    return true;
  }
}
