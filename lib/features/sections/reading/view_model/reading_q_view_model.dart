import 'dart:async';

import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/utils/utils.dart';

class ReadingQuestionViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  final FirestoreService _firestoreService = FirestoreService();
  List<BaseQuestion> _questions = [];

  int get selectedLevel => _selectedLevelId;
  List<BaseQuestion> get questions => _questions;

  Future<void> fetchQuestions(String section, String level) async {
    isLoading = true;
    // notifyListeners();
    try {
      _questions = await _firestoreService.fetchQuestions(section, level);
      error = null;
    } on CustomException catch (e) {
      // error = e as CustomException;
      _handleError(e.message);
      notifyListeners();
    } catch (e) {
      _handleError("An undefined error occurred ${e.toString()}");
    } finally {
      isLoading = false;
      // notifyListeners();
    }
  }

  @override
  FutureOr<void> init() {}

  void _handleError(String e) {
    Utils.showSnackBar(e);
    // errorOccurred = true;
    // navigatorKey.currentState!.pop();
  }
}
