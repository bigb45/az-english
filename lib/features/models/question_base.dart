abstract class QuestionBase {
  String questionText;
  String imageUrl;
  String voiceUrl;

  QuestionBase({
    required this.questionText,
    required this.imageUrl,
    required this.voiceUrl,
  });

  Map<String, dynamic> toJson();

  factory QuestionBase.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson not implemented');
  }
}
