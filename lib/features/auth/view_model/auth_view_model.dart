import 'package:ez_english/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          email: email, password: password);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // TODO: Handle errors effectively
      Navigator.of(context).pop();
      _showErrorDialog(context, e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  void _showErrorDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message ?? 'An unknown error occurred'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}
