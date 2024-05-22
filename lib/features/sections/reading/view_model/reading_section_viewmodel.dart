import 'dart:async';

import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingQuestionViewmodel extends BaseViewModel {
  String? _levelId;
  String? _sectionName;
  String? _levelName;
  String? _sectionId;

  String? get sectionId => _sectionId;
  String? get sectionName => _sectionName;
  String? get levelName => _levelName;
  String? get levelId => _levelId;

  set sectionName(String? value) {
    _sectionName = value;
  }

  set levelName(String? value) {
    _levelName = value;
  }

  set levelId(String? value) {
    _levelId = value;
  }

  set sectionId(String? value) {
    _sectionId = value;
  }

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  List<BaseQuestion> _questions = [];
  late AuthViewModel _authProvider;
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
    int lastQuestionIndex = _authProvider.userData!.levelsProgress![levelName]!
        .sectionProgress![sectionName]!.lastStoppedQuestionIndex;
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
      notifyListeners();
    }
  }

  Future<void> updateSectionProgress(int newQuestionIndex) async {
    User? currentUser = _firebaseAuthService.getUser();
    isLoading = true;
    // TODO change it to the total number of questions(10) after testing
    // TODO WDYT of this formula????
    newQuestionIndex = (3 - questions.length) + newQuestionIndex;
    notifyListeners();
    try {
      await _firestoreService.updateQuestionProgress(
          userId: currentUser!.uid,
          levelName: levelName!,
          sectionName: sectionName!,
          newQuestionIndex: newQuestionIndex);
      error = null;
    } on CustomException catch (e) {
      // error = e as CustomException;
      _handleError(e.message);
      notifyListeners();
    } catch (e) {
      _handleError("An undefined error occurred ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  FutureOr<void> init() {}

  void _handleError(String e) {
    Utils.showSnackBar(e);
  }
}
