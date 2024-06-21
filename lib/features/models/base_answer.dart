abstract class BaseAnswer<T> {
  final AnswerType answerType;
  T? answer;
  bool validate(T userAnswer);
  Map<String, dynamic> toMap();
  BaseAnswer({required this.answerType, this.answer});
}

enum AnswerType { string, multipleChoice, checkbox, fillTheBlanks, dictation }
