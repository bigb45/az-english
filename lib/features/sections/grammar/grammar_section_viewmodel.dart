import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/grammar/model/grammar_question_model.dart';

class GrammarSectionViewmodel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  List<BaseQuestion> _questions = [];
  bool _isLoading = false;
  int _currentQuestionIndex = 0;
  String _userAnswer = "";
  EvaluationState _answerState = EvaluationState.empty;

  EvaluationState get answerState => _answerState;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<BaseQuestion> get questions => _questions;
  bool get isLoding => _isLoading;
  String get userAnswer => _userAnswer;

  @override
  void init() {}

  void myInit() async {
    // reset answerState
    _answerState = EvaluationState.empty;
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    _isLoading = true;
    try {
      // TODO: replace with actual data
      // _questions = await _firestoreService.fetchQuestions("grammar", "1", 0);

      _questions = [
        GrammarQuestionModel(
            questionType: QuestionType.youtubeLesson,
            question: "Watch the following video",
            words: "",
            correctAnswer: "",
            youtubeUrl: "JGwWNGJdvx8"),
        GrammarQuestionModel(
          questionType: QuestionType.sentenceForming,
          question: "A cat is sleeping",
          words: "cat is sleeping are am the a",
          correctAnswer: "A cat is sleeping",
        ),
      ];
      notifyListeners();
    } catch (e) {
      print("error while fetching questions: $e");

      // TODO: show error in ui
    }
  }

  void evaluateAnswer() {
    _answerState = (questions[_currentQuestionIndex] as GrammarQuestionModel)
                .correctAnswer
                .toLowerCase() ==
            userAnswer.toLowerCase()
        ? EvaluationState.correct
        : EvaluationState.incorrect;

    notifyListeners();
  }

  void updateAnswer(String newAnswer) {
    _userAnswer = newAnswer;
    notifyListeners();
  }

  void updateSectionProgress() {
    _currentQuestionIndex++;
    notifyListeners();
  }
}
