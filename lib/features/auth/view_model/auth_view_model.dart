import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  bool errorOccurred = false;

  User? _user;

  User? get user => _user;

  UserModel? _userData;
  UserModel? get userData => _userData;

  bool get isSignedIn => _user != null;
  // bool get isSignedIn => true;
  AuthViewModel() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
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
      UserCredential? userCredential = await _firebaseAuthService.signUp(user);
      if (userCredential == null) return;
      if (userCredential.user != null) {
        user.id = userCredential.user!.uid;
        user.assignedLevels = [];
        await _firestoreService.addUser(user);
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

  void _onAuthStateChanged(User? user) async {
    _user = user;
    if (_user != null) {
      _userData = await _firestoreService.getUser(_user!.uid);
    }
    notifyListeners();
  }

  void _handleError(String e) {
    Utils.showSnackBar(e);
    errorOccurred = true;
    navigatorKey.currentState!.pop();
  }
}
