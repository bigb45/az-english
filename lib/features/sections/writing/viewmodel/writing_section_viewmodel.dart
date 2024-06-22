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
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:ez_english/widgets/radio_button.dart';

class WritingSectionViewmodel extends BaseViewModel {
  final sectionId = "2";

  String? _levelName;
  String? levelId;
  final List<BaseQuestion> _questions = [
    MultipleChoiceQuestionModel(
      questionTextInArabic: "What is the plural of 'goose'?",
      questionTextInEnglish: "What is the plural of 'goose'?",
      options: [
        RadioItemData(title: "Geese", value: "geese"),
        RadioItemData(title: "Gooses", value: "gooses"),
        RadioItemData(title: "Geeses", value: "geeses"),
        RadioItemData(title: "Gees", value: "gees"),
      ],
      // questionText: "What is the plural of 'goose'?",
      imageUrl: "",
      // voiceUrl: "",
      answer: MultipleChoiceAnswer(
        answer: RadioItemData(title: "Geese", value: "geese"),
      ),
    ),
    DictationQuestionModel(
      questionTextInArabic: "Dictate the following text",
      questionTextInEnglish: "Dictate the following text",
      voiceUrl: "",
      speakableText: "The quick brown fox",
      answer: StringAnswer(
        answer: "The quick brown fox",
      ),
    ),
  ];

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
      // _questions =
      //     await _firestoreService.fetchQuestions(_sectionName, _levelName!, 0);
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

  void updateAnswer(BaseAnswer answer) {
    _questions[currentIndex].userAnswer = answer;
    notifyListeners();
  }

  void evaluateAnswer() {
    if (_questions[currentIndex].evaluateAnswer()) {
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
