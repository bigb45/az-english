import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/utils/utils.dart';

class ReadingSectionViewmodel extends BaseViewModel {
  String? levelId;
  PassageQuestionModel? _passageQuestion;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  List<BaseQuestion?> _questions = [];

  List<BaseQuestion?> get questions => _questions;
  PassageQuestionModel? get passageQuestion => _passageQuestion;

  @override
  FutureOr<void> init() {}

  void setValuesAndInit() async {
    currentIndex = 0;
    progress = progress;
    levelName = RouteConstants.getLevelName(levelId!);
    sectionName = RouteConstants.readingSectionName;
    answerState = EvaluationState.empty;
    await fetchQuestions();
    if (_questions.isNotEmpty &&
            _questions[currentIndex]?.questionType ==
                QuestionType.youtubeLesson ||
        _questions[currentIndex]?.questionType ==
            QuestionType.vocabularyWithListening ||
        _questions[currentIndex]?.questionType == QuestionType.whiteboard) {
      answerState = EvaluationState.noState;
    }
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    try {
      Unit unit = await _firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.readingSectionName]!,
        levelName!,
      );

      if (unit.questions.isNotEmpty &&
          unit.questions.values.first is PassageQuestionModel) {
        _passageQuestion = unit.questions.values.first as PassageQuestionModel;
        _questions = unit.questions.values.skip(1).toList();
      } else {
        _questions = unit.questions.values.cast<BaseQuestion>().toList();
      }
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

  void incrementIndex() {
    if (currentIndex < questions.length) {
      currentIndex = currentIndex + 1;
      progress = _firestoreService.calculateNewProgress(currentIndex);
      if (currentIndex < _questions.length &&
          shouldSkipValidation(_questions[currentIndex])) {
        answerState = EvaluationState.noState;
      } else {
        answerState = EvaluationState.empty;
      }
    }
  }

  void updateAnswer(BaseAnswer newAnswer) {
    _questions[currentIndex]?.userAnswer = newAnswer;
    notifyListeners();
  }

  void reset() {
    levelId = null;
    _passageQuestion = null;
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

  void evaluateAnswer() {
    if (_questions[currentIndex] != null &&
        _questions[currentIndex]!.evaluateAnswer()) {
      answerState = EvaluationState.correct;
    } else {
      answerState = EvaluationState.incorrect;
      wrongAnswerCount += 1;
    }
  }
}
