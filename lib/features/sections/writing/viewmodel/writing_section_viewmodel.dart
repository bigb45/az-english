import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';

class WritingSectionViewmodel extends BaseViewModel {
  final sectionId = "2";
  final _sectionName = "writing";
  String? _levelName;
  String? levelId;
  List<BaseQuestion> _questions = [];
  // TODO: handle dynamic user answer for different question types
  // maybe make base answer class? and extend it for each question type
  // and each answer class will have its own validation method

  dynamic _userAnswer;

  // List<BaseQuestion> _questions = [
  //   MultipleChoiceQuestionModel(
  //     options: [
  //       RadioItemData(title: "Geese", value: "geese"),
  //       RadioItemData(title: "Gooses", value: "gooses"),
  //       RadioItemData(title: "Geeses", value: "geeses"),
  //       RadioItemData(title: "Gees", value: "gees"),
  //     ],
  //     questionText: "What is the plural of 'goose'?",
  //     imageUrl: "",
  //     voiceUrl: "",
  //     answer: RadioItemData(title: "Geese", value: "geese"),
  //   ),
  //   DictationQuestionModel(
  //     questionText: "Dictate the following text",
  //     imageUrl: "",
  //     voiceUrl: "",
  //     answer: "Dictate the following text",
  //   ),
  // ];

  get questions => _questions;
  get userAnswer => _userAnswer;
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
      _questions =
          await _firestoreService.fetchQuestions(_sectionName, _levelName!, 0);
      error = null;
    } on CustomException catch (e) {
      error = e;

      notifyListeners();
    } catch (e) {
      // TODO: assign error to 'error' variable here and handle state in UI
      // error = CustomException(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateAnswer<T>(T answer) {
    _userAnswer = answer;
    notifyListeners();
  }

  void evaluateAnswer() {
    if (_questions[currentIndex].answer == _userAnswer) {
      answerState = EvaluationState.correct;
    } else {
      answerState = EvaluationState.incorrect;
    }
  }

  void incrementIndex() {
    if (currentIndex < _questions.length - 1) {
      currentIndex = currentIndex + 1;
      notifyListeners();
    }
  }
}
