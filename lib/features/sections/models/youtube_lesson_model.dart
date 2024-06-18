import 'package:ez_english/features/models/base_question.dart';

class YoutubeLessonModel extends BaseQuestion {
  final String? youtubeUrl;

  YoutubeLessonModel({this.youtubeUrl})
      : super(
          questionType: QuestionType.youtubeLesson,
          questionTextInEnglish: "",
          questionTextInArabic: "",
          imageUrl: "",
          voiceUrl: "",
        );
}
