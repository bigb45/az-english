import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:ez_english/widgets/radio_button.dart';

class WritingSectionViewmodel extends BaseViewModel {
  final sectionId = "2";
  final _sectionName = "writing";
  int _currentQuestionIndex = 0;
  String? _levelName;
  String? levelId;
  List<BaseQuestion> _questions = [
    MultipleChoiceQuestionModel(
      options: [
        RadioItemData(title: "Geese", value: "geese"),
        RadioItemData(title: "Gooses", value: "gooses"),
        RadioItemData(title: "Geeses", value: "geeses"),
        RadioItemData(title: "Gees", value: "gees"),
      ],
      questionText: "What is the plural of 'goose'?",
      imageUrl: "",
      voiceUrl: "",
      answer: RadioItemData(title: "Geese", value: "geese"),
    ),
    DictationQuestionModel(
      questionText: "Dictate the following text",
      imageUrl: "",
      voiceUrl: "",
      answer: "Dictate the following text",
    ),
  ];

  get questions => _questions;
  get currentQuestionIndex => _currentQuestionIndex;

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  @override
  FutureOr<void> init() {}

  Future<void> myInit() async {
    _levelName = RouteConstants.getLevelName(levelId!);
    final user =
        await _firestoreService.getUser(_firebaseAuthService.getUser()!.uid);
    fetchQuestions(user!);
    print("got questions! ${_questions.length}");
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

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      print("Moving on");
      _currentQuestionIndex++;
      notifyListeners();
    }
  }
}
