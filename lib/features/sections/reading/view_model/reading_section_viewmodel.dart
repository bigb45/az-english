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
    fetchQuestions();
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
    if (currentIndex < questions.length - 1) {
      currentIndex = currentIndex + 1;
      progress = _firestoreService.calculateNewProgress(currentIndex);
      answerState = EvaluationState.empty;
    }
  }

  void updateAnswer(BaseAnswer newAnswer) {
    _questions[currentIndex]?.userAnswer = newAnswer;
    notifyListeners();
  }

  void evaluateAnswer() {
    if (_questions[currentIndex] != null &&
        _questions[currentIndex]!.evaluateAnswer()) {
      answerState = EvaluationState.correct;
    } else {
      answerState = EvaluationState.incorrect;
    }
  }
}
