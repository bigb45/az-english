import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/utils/utils.dart';

class SpeakingSectionViewmodel extends BaseViewModel {
  String? levelId;
  List<BaseQuestion> _questions = [];
  get questions => _questions;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  FutureOr<void> init() {}

  Future<void> setValuesAndInit() async {
    currentIndex = 0;
    levelName = RouteConstants.getLevelName(levelId!);
    // TODO: change this to speakingSectionName
    sectionName = RouteConstants.listeningSectionName;

    fetchQuestions();
    if (_questions.isNotEmpty &&
        _questions[currentIndex].questionType == QuestionType.youtubeLesson) {
      answerState = EvaluationState.noState;
    }
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    printDebug("beginning");
    try {
      printDebug("fetching questions");
      Unit unit = await _firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.listeningSectionName]!,
        levelName!,
      );
      _questions = unit.questions.values.cast<BaseQuestion>().toList();
      progress = unit.progress;
      error = null;
    } on CustomException catch (e) {
      error = e;
    } catch (e) {
      printDebug("caught exception: $e");
      error = CustomException(e.toString());
    } finally {
      printDebug("finally");
      isLoading = false;
      notifyListeners();
    }
  }

  void updateAnswer(BaseAnswer answer) {
    _questions[currentIndex].userAnswer = answer;
    notifyListeners();
  }

  void evaluateAnswer() {
    if (_questions[currentIndex].evaluateAnswer()) {
      answerState = EvaluationState.correct;
    } else {
      wrongAnswerCount += 1;
      answerState = EvaluationState.incorrect;
    }
  }

  void incrementIndex() {
    if (currentIndex < _questions.length) {
      currentIndex = currentIndex + 1;
      progress = _firestoreService.calculateNewProgress(currentIndex);
      if (_questions[currentIndex].questionType == QuestionType.youtubeLesson ||
          _questions[currentIndex].questionType ==
              QuestionType.vocabularyWithListening) {
        answerState = EvaluationState.noState;
      } else {
        answerState = EvaluationState.empty;
      }
    }
  }

  void reset() {
    _questions.clear();
    currentIndex = 0;
    levelName = null;
    sectionName = null;
    progress = 0.0;
    isInitialized = false;
    isLoading = false;
    error = null;
    notifyListeners();
  }
}
