import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';

import '../../models/word_model.dart';

class VocabularySectionViewmodel extends BaseViewModel {
  late List<WordModel> _words;
  String? levelId;
  String? _levelName;
  String? get levelName => _levelName;
  List<BaseQuestion?> _questions = [];

  List<BaseQuestion?> get questions => _questions;
  get words => _words;

  @override
  FutureOr<void> init() {
    _words = [];
  }

  void setValuesAndInit() async {
    currentIndex = 0;
    _levelName = RouteConstants.getLevelName(levelId!);
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    // int lastQuestionIndex = _userData!.levelsProgress![levelName]!
    //     .sectionProgress![_sectionName]!.lastStoppedQuestionIndex;
    try {
      _questions = await firestoreService.fetchQuestions(
        RouteConstants.vocabularySectionName,
        _levelName!,
        0,
      );

      error = null;
    } on CustomException catch (e) {
      error = e;
      notifyListeners();
    } catch (e) {
      error = CustomException("An undefined error occurred $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
