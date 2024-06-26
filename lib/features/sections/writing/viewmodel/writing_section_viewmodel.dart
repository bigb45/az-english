import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';

class WritingSectionViewmodel extends BaseViewModel {
  final sectionId = "2";

  String? _levelName;
  String? levelId;
  List<BaseQuestion> _questions = [];

  // dynamic _userAnswer;

  get questions => _questions;
  // get userAnswer => _userAnswer;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  @override
  FutureOr<void> init() {}

  Future<void> myInit() async {
    _levelName = RouteConstants.getLevelName(levelId!);
    final user =
        await _firestoreService.getUser(_firebaseAuthService.getUser()!.uid);
    fetchQuestions(user!);
  }

  Future<void> fetchQuestions(UserModel userData) async {
    isLoading = true;

    // int lastQuestionIndex = userData.levelsProgress![_levelName]!
    //     .sectionProgress![_sectionName]!.lastStoppedQuestionIndex;
    try {
      var fetchedQuestions = await _firestoreService.fetchQuestions(
        RouteConstants.writingSectionName,
        _levelName!,
        unitName: "Unit2",
        0,
      );
      _questions = fetchedQuestions.cast<BaseQuestion>();

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
