abstract class BaseAnswer<T> {
  final AnswerType answerType;
  T? answer;
  T? userAnswer;
  bool? validate(BaseAnswer? userAnswer);
  Map<String, dynamic> toMap() {
    return {
      'answerType': answerType.toString(),
      'answer': answer,
    };
  }

  BaseAnswer({required this.answerType, this.answer});
}

enum AnswerType { string, multipleChoice, checkbox, fillTheBlanks, dictation }
