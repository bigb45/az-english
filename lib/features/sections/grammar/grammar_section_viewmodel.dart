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
  String? _levelName;
  List<BaseQuestion> _questions = [];

  List<BaseQuestion> get questions => _questions;

  String? get levelName => _levelName;
  @override
  void init() {}

  void setValuesAndInit() async {
    // reset answerState
    currentIndex = 0;
    answerState = EvaluationState.empty;
    _levelName = RouteConstants.getLevelName(levelId!);
    await fetchQuestions();
    if (_questions[currentIndex].questionType == QuestionType.youtubeLesson) {
      answerState = EvaluationState.noState;
    }
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    try {
      Unit unit = await _firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.grammarSectionName]!,
        _levelName!,
        0,
      );

      _questions = unit.questions.values.cast<BaseQuestion>().toList();

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
    }
  }

  void updateAnswer(BaseAnswer newAnswer) {
    _questions[currentIndex].userAnswer = newAnswer;
    notifyListeners();
  }

  void incrementIndex() {
    if (questions.length - 1 > currentIndex) {
      currentIndex++;
    }
    if (_questions[currentIndex].questionType == QuestionType.youtubeLesson) {
      answerState = EvaluationState.noState;
    } else {
      answerState = EvaluationState.empty;
    }
  }
}
