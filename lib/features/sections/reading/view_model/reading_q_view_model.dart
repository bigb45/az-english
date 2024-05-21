import 'dart:async';

import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/utils/utils.dart';

class ReadingQuestionViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  final FirestoreService _firestoreService = FirestoreService();
  List<BaseQuestion> _questions = [];
  late AuthViewModel _authProvider;
  int get selectedLevel => _selectedLevelId;
  List<BaseQuestion> get questions => _questions;
  void update(AuthViewModel authViewModel) {
    _authProvider = authViewModel;
    // if (_authProvider.isSignedIn) {

    // }
  }

  Future<void> fetchQuestions(String levelName, String levelId,
      String sectionName, String sectionId) async {
    isLoading = true;
    // notifyListeners();

    int lastQuestionIndex = _authProvider
        .userDate!
        .levelsProgress![int.parse(levelId)]
        .sectionProgress[int.parse(sectionId)]
        .lastStoppedQuestionIndex;
    try {
      _questions = await _firestoreService.fetchQuestions(
          sectionName, levelName, lastQuestionIndex);
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
