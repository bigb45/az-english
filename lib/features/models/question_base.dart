abstract class BaseQuestion {
  String questionText;
  String imageUrl;
  String voiceUrl;

  BaseQuestion({
    required this.questionText,
    required this.imageUrl,
    required this.voiceUrl,
  });

  Map<String, dynamic> toJson();

  factory BaseQuestion.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson not implemented');
  }
}
