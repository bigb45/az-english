import 'dart:async';

import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/test_result.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  List<TestResult> _examResults = [];

  int get selectedLevel => _selectedLevelId;
  List<TestResult> get examResults => _examResults;

  Future<void> myInit() async {
    isLoading = true;
    User user = _firebaseAuthService.getUser()!;
    UserModel? userModel = await firestoreService.getUser(user.uid);
    if (userModel != null) {
      _examResults = userModel.examResults?.values.toList() ?? [];
    }
    isInitialized = true;
    isLoading = false;
    notifyListeners();
  }

  void reset() {
    _selectedLevelId = 0;
    _examResults = [];
    notifyListeners();
  }

  void _handleError(String e) {
    Utils.showSnackBar(e);
    // errorOccurred = true;
    // navigatorKey.currentState!.pop();
  }

  @override
  FutureOr<void> init() {
    // TODO: implement init
  }
}
