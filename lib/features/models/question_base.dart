abstract class QuestionBase {
  String questionText;
  String image;
  String voice;

  QuestionBase({
    required this.questionText,
    required this.image,
    required this.voice,
  });

  Map<String, dynamic> toJson();

  factory QuestionBase.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson not implemented');
  }
}
