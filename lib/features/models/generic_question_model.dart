class GenericQuestionModel<T> {
  final String? question;
  final QuestionType questionType;
  final T answer;
  final List<T>? options;
  final T? hint;
  final String? imageUrl;
  final bool enableDebugging;
  bool validateQuestion({T? correctAnswer, required T userAnswer}) {
    correctAnswer = correctAnswer ?? answer;
    if (enableDebugging) {
      if (userAnswer == correctAnswer) {
        print("correct");
      } else {
        print(
            "incorrect, user answered: $userAnswer, correct answer: $correctAnswer");
      }
    }
    return userAnswer == correctAnswer;
  }

  GenericQuestionModel({
    required this.question,
    required this.answer,
    required this.questionType,
    this.options,
    this.hint,
    this.imageUrl,
    this.enableDebugging = true,
  });
}

enum QuestionType {
  multipleChoice,
  dictation,
  fillInTheBlank,
  trueOrFalse,
  radioQuestion,
  checkBoxQuestion,
}
