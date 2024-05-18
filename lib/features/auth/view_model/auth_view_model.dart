import 'package:ez_english/router.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;

  bool get isSignedIn => _user != null;

  AuthViewModel() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    // TODO change the lodaing design
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      // TODO: Handle errors effectively
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      navigatorKey.currentState!.pop();
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      Utils.showSnackBar("Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      navigatorKey.currentState!.pop();
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> signOut(BuildContext context) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      navigatorKey.currentState!.pop();
    }
    // TODO try to fix navigation stack,  ensure that if the user logs in from the sign-up screen and later signs out, they are directed back to the sign-up screen
    // if (context.mounted) context.push("/sign_up");
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}
