import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/sentence_forming_question_model.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';

class GrammarSectionViewmodel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  List<BaseQuestion> _questions = [];
  bool _isLoading = false;

  List<BaseQuestion> get questions => _questions;
  bool get isLoding => _isLoading;

  @override
  void init() {}

  @override
  void dispose() {
    answerState = EvaluationState.empty;
    currentIndex = 0;
    super.dispose();
  }

  void myInit() async {
    // reset answerState
    answerState = EvaluationState.empty;
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    _isLoading = true;
    try {
      // TODO: replace with actual data
      // _questions = await _firestoreService.fetchQuestions("grammar", "1", 0);

      _questions = [
        SentenceFormingQuestionModel(
          question: "Form a sentence from the words below:",
          words: "cat is sleeping are am the a",
          correctAnswer: "A cat is sleeping",
        ),
        YoutubeLessonModel(youtubeUrl: "JGwWNGJdvx8"),
        // MultipleChoiceQuestionModel(
        //     options: options,
        //     answer: answer,
        //     questionTextInArabic: questionTextInArabic,
        //     questionTextInEnglish: questionTextInEnglish,
        //     imageUrl: imageUrl)
      ];
      notifyListeners();
    } catch (e) {
      print("error while fetching questions: $e");
      // TODO: show error in ui
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
    answerState = EvaluationState.empty;
  }
}
