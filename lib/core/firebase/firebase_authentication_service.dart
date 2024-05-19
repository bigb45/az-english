import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  bool errorOccurred = false;

  Future<void> signIn(UserModel user) async {
    errorOccurred = false;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: user.emailAddress.trim(), password: user.password.trim());
    } on FirebaseAuthException catch (e) {
      // TODO: Handle errors effectively
      _handleError(e);
    }
    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future<void> signUp(UserModel user) async {
    errorOccurred = false;
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.emailAddress, password: user.password);
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: user.emailAddress.trim(), password: user.password.trim());
      if (userCredential.user != null) {
        user.id = userCredential.user!.uid;
        await _firestoreService.addUser(user);
      }
    } on FirebaseAuthException catch (e) {
      _handleError(e);
    }
    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future<void> resetPassword(String email) async {
    errorOccurred = false;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      Utils.showSnackBar("Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      _handleError(e);
    }
    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future<void> signOut() async {
    errorOccurred = false;
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      _handleError(e);
    }
    // TODO try to fix navigation stack,  ensure that if the user logs in from the sign-up screen and later signs out, they are directed back to the sign-up screen
    if (!errorOccurred) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  void _handleError(FirebaseAuthException e) {
    Utils.showSnackBar(e.message);
    errorOccurred = true;
    navigatorKey.currentState!.pop();
  }
}
