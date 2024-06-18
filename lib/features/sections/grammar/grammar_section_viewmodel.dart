import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/grammar/model/grammar_question_model.dart';

class GrammarSectionViewmodel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  List<BaseQuestion> _questions = [];
  bool _isLoading = false;
  String _userAnswer = "";

  List<BaseQuestion> get questions => _questions;
  bool get isLoding => _isLoading;
  String get userAnswer => _userAnswer;

  @override
  void init() {}

  @override
  void dispose() {
    answerState = EvaluationState.empty;
    currentIndex = 0;
    _userAnswer = "";
    super.dispose();
  }

  void myInit() async {
    // reset answerState
    answerState = EvaluationState.empty;
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    _isLoading = true;
    try {
      // TODO: replace with actual data
      // _questions = await _firestoreService.fetchQuestions("grammar", "1", 0);

      _questions = [
        GrammarQuestionModel(
          questionType: QuestionType.sentenceForming,
          question: "A cat is sleeping",
          words: "cat is sleeping are am the a",
          correctAnswer: "A cat is sleeping",
        ),
        GrammarQuestionModel(
            questionType: QuestionType.youtubeLesson,
            question: "Watch the following video",
            words: "",
            correctAnswer: "",
            youtubeUrl: "JGwWNGJdvx8"),
      ];
      notifyListeners();
    } catch (e) {
      print("error while fetching questions: $e");
      // TODO: show error in ui
    }
  }

  void evaluateAnswer() {
    answerState = switch (questions[currentIndex].questionType) {
      QuestionType.sentenceForming =>
        (questions[currentIndex] as GrammarQuestionModel)
                    .correctAnswer
                    .toLowerCase() ==
                userAnswer.toLowerCase()
            ? EvaluationState.correct
            : EvaluationState.incorrect,
      QuestionType.youtubeLesson => EvaluationState.correct,
      _ => throw UnimplementedError(),
    };
    print(
        "updating state: $currentIndex $answerState, ${(questions[currentIndex] as GrammarQuestionModel).correctAnswer}, $userAnswer");
  }

  void updateAnswer(String newAnswer) {
    _userAnswer = newAnswer;
    notifyListeners();
  }

  void updateSectionProgress() {
    if (questions.length - 1 > currentIndex) {
      currentIndex++;
      _userAnswer = "";
    }
    answerState = EvaluationState.empty;
  }
}
