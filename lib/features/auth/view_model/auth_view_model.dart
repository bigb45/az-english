import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  User? _user;

  User? get user => _user;

  // bool get isSignedIn => _user != null;
  bool get isSignedIn => true;
  AuthViewModel() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signIn(UserModel user, BuildContext context) async {
    // TODO change the lodaing design
    _showDialog(context);
    await _firebaseAuthService.signIn(user);
  }

  Future<void> signUp(UserModel user, BuildContext context) async {
    _showDialog(context);
    await _firebaseAuthService.signUp(user);
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    _showDialog(context);
    await _firebaseAuthService.resetPassword(email);
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuthService.signOut();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }
}
