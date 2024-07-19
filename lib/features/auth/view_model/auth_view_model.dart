import 'dart:async';

import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/home/viewmodel/test_viewmodel.dart';
import 'package:ez_english/features/levels/screens/level_selection_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/sections/grammar/grammar_section_viewmodel.dart';
import 'package:ez_english/features/sections/reading/view_model/reading_section_viewmodel.dart';
import 'package:ez_english/features/sections/vocabulary/viewmodel/vocabulary_section_viewmodel.dart';
import 'package:ez_english/features/sections/writing/viewmodel/writing_section_viewmodel.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  bool errorOccurred = false;

  User? _user;

  User? get user => _user;

  UserModel? _userData;
  UserModel? get userData => _userData;
  StreamSubscription<User?>? _authStateSubscription;

  bool get isSignedIn => _user != null;
  // bool get isSignedIn => true;
  AuthViewModel() {
    _subscribeToAuthChanges();
  }
  void _subscribeToAuthChanges() {
    _authStateSubscription =
        _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _unsubscribeFromAuthChanges() {
    _authStateSubscription?.cancel();
  }

  //TODO remove this after testing
  Future<void> signInDev() async {
    errorOccurred = false;
    try {
      final tempUser = UserModel(emailAddress: "r@g.com", password: "123456");
      await _firebaseAuthService.signIn(tempUser);
    } on CustomException catch (e) {
      errorOccurred = true;
      _handleError(e.message);
    } catch (e) {
      print("object");
    }
    // if (!errorOccurred) {
    //   navigatorKey.currentState!.popUntil((route) => route.isFirst);
    // }
  }

  Future<void> signIn(UserModel user, BuildContext context) async {
    // TODO change the lodaing design
    _showDialog(context);
    errorOccurred = false;
    try {
      await _firebaseAuthService.signIn(user);
    } on CustomException catch (e) {
      errorOccurred = true;
      _handleError(e.message);
    }
    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future<void> signUp(UserModel user, BuildContext context) async {
    _showDialog(context);
    errorOccurred = false;
    try {
      _unsubscribeFromAuthChanges();
      UserCredential? userCredential = await _firebaseAuthService.signUp(user);
      if (userCredential == null) return;
      if (userCredential.user != null) {
        user.id = userCredential.user!.uid;
        user.assignedLevels = [];
        await _firestoreService.addUser(user);
        _subscribeToAuthChanges();
      }
    } on CustomException catch (e) {
      errorOccurred = true;
      _handleError(e.message);
    }

    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    _showDialog(context);
    errorOccurred = false;

    try {
      await _firebaseAuthService.resetPassword(email);
    } on CustomException catch (e) {
      errorOccurred = true;
      _handleError(e.message);
    }
    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future<void> signOut(BuildContext context) async {
    errorOccurred = false;
    try {
      await _firebaseAuthService.signOut();
      _firestoreService.reset();
      _resetAuthState();
      Provider.of<WritingSectionViewmodel>(context, listen: false).reset();
      Provider.of<ReadingSectionViewmodel>(context, listen: false).reset();
      Provider.of<VocabularySectionViewmodel>(context, listen: false).reset();
      Provider.of<GrammarSectionViewmodel>(context, listen: false).reset();
      Provider.of<LevelSelectionViewmodel>(context, listen: false).reset();
      Provider.of<TestViewmodel>(context, listen: false).reset();
    } on CustomException catch (e) {
      errorOccurred = true;
      _handleError(e.message);
    }
    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _resetAuthState() {
    _user = null;
    _userData = null;
    notifyListeners();
  }

  void _onAuthStateChanged(User? user) async {
    _user = user;
    if (_user != null) {
      _userData = await _firestoreService.getUser(_user!.uid);
    }
    notifyListeners();
  }

  void _handleError(String e) {
    Utils.showErrorSnackBar(e);
    errorOccurred = true;
    navigatorKey.currentState!.pop();
  }
}
