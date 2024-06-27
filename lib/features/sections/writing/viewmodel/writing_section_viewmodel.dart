import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';

class WritingSectionViewmodel extends BaseViewModel {
  final sectionId = "2";

  String? _levelName;
  String? levelId;
  List<BaseQuestion> _questions = [];

  get questions => _questions;
  // get userAnswer => _userAnswer;
  final FirestoreService _firestoreService = FirestoreService();
  // final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  @override
  FutureOr<void> init() {}

  Future<void> myInit() async {
    currentIndex = 0;
    _levelName = RouteConstants.getLevelName(levelId!);
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    // UserModel userData = (await _firestoreService.getUser(_firebaseAuthService.getUser()!.uid))!;
    // int lastQuestionIndex = userData.levelsProgress![_levelName]!
    //     .sectionProgress![_sectionName]!.lastStoppedQuestionIndex;
    try {
      Unit unit = await _firestoreService.fetchUnit(
        RouteConstants
            .sectionNameId[RouteConstants.listeningWritingSectionName]!,
        _levelName!,
        // TODO: change unit name to be a variable
        unitName: "Unit2",
        0,
      );
      _questions = unit.questions.values.cast<BaseQuestion>().toList();

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
    _questions[currentIndex].userAnswer = answer;
    notifyListeners();
  }

  void evaluateAnswer() {
    if (_questions[currentIndex].evaluateAnswer()) {
      // TODO: perform scoring logic here
      answerState = EvaluationState.correct;
    } else {
      answerState = EvaluationState.incorrect;
    }
  }

  void incrementIndex() {
    if (currentIndex < _questions.length - 1) {
      currentIndex = currentIndex + 1;
      answerState = EvaluationState.empty;
    }
  }
}
