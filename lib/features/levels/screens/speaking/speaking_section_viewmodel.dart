import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpeakingSectionViewmodel extends BaseViewModel {
  String? levelId;
  List<BaseQuestion> _questions = [];
  get questions => _questions;

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  FutureOr<void> init() {}

  Future<void> setValuesAndInit() async {
    currentIndex = 0;
    levelName = RouteConstants.getLevelName(levelId!);
    sectionName = RouteConstants.speakingSectionName;

    fetchQuestions();
    if (_questions.isNotEmpty &&
        _questions[currentIndex].questionType == QuestionType.youtubeLesson) {
      answerState = EvaluationState.noState;
    }
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    try {
      User? user = _firebaseAuthService.getUser();
      var questions = await _firestoreService.fetchAssignedQuestions(
          user: user!, sectionName: RouteConstants.speakingSectionName);
      _questions = questions.questions.values.cast<BaseQuestion>().toList();
      progress = questions.progress;
      error = null;
    } on CustomException catch (e) {
      error = e;
    } catch (e) {
      error = CustomException(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateAnswer(BaseAnswer answer) {
    BaseQuestion question = _questions[currentIndex];
    if (question.questionType == QuestionType.passage) {
      PassageQuestionModel passageQuestion = question as PassageQuestionModel;
      question = passageQuestion.questions.entries.first.value!;
    }
    question.userAnswer = answer;
    notifyListeners();
  }

  void evaluateAnswer() {
    BaseQuestion question = _questions[currentIndex];
    if (question.questionType == QuestionType.passage) {
      PassageQuestionModel passageQuestion = question as PassageQuestionModel;
      question = passageQuestion.questions.entries.first.value!;
    }
    if (question.evaluateAnswer()) {
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

  @override
  Future<void> updateSectionProgress() async {
    _firestoreService.updateCurrentSectionQuestionIndexForAssignedQuestions(
        currentIndex, sectionName!);
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
