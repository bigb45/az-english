import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';

class GrammarSectionViewmodel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  String? levelId;
  List<BaseQuestion> _questions = [];

  List<BaseQuestion> get questions => _questions;

  @override
  void init() {}

  void setValuesAndInit() async {
    // reset answerState
    currentIndex = 0;
    answerState = EvaluationState.empty;
    levelName = RouteConstants.getLevelName(levelId!);
    sectionName = RouteConstants.grammarSectionName;
    await fetchQuestions();
    if (_questions.isNotEmpty &&
        _questions[currentIndex].questionType == QuestionType.youtubeLesson) {
      answerState = EvaluationState.noState;
    }
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    try {
      Unit unit = await _firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.grammarSectionName]!,
        levelName!,
      );

      _questions = unit.questions.values.cast<BaseQuestion>().toList();
      progress = unit.progress;

      error = null;
    } on CustomException catch (e) {
      error = e;
    } catch (e) {
      error = CustomException("An undefined error occurred $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void evaluateAnswer() {
    if (questions[currentIndex].evaluateAnswer()) {
      answerState = EvaluationState.correct;
    } else {
      answerState = EvaluationState.incorrect;
      wrongAnswerCount += 1;
    }
  }

  void updateAnswer(BaseAnswer newAnswer) {
    _questions[currentIndex].userAnswer = newAnswer;
    notifyListeners();
  }

  void reset() {
    levelId = null;
    _questions.clear();
    currentIndex = 0;
    levelName = null;
    sectionName = null;
    progress = 0.0;
    isInitialized = false;
    isLoading = false;
    error = null;
    answerState = EvaluationState.empty;
    notifyListeners();
  }

  void incrementIndex() {
    if (currentIndex < _questions.length) {
      currentIndex = currentIndex + 1;
      progress = _firestoreService.calculateNewProgress(currentIndex);
      if (currentIndex < _questions.length &&
          (_questions[currentIndex].questionType ==
                  QuestionType.youtubeLesson ||
              _questions[currentIndex].questionType ==
                  QuestionType.vocabularyWithListening)) {
        answerState = EvaluationState.noState;
      } else {
        answerState = EvaluationState.empty;
      }
    }
  }
}
