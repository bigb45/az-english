import 'package:ez_english/features/models/base_question.dart';

class YoutubeLessonModel extends BaseQuestion {
  final String? youtubeUrl;

  YoutubeLessonModel(
      {required this.youtubeUrl,
      super.questionType = QuestionType.youtubeLesson,
      super.voiceUrl,
      super.questionTextInEnglish,
      super.questionTextInArabic,
      super.imageUrl});

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
    );
  }
}
