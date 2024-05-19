import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn(UserModel user) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: user.emailAddress.trim(), password: user.password.trim());
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    }
  }

  Future<UserCredential?> signUp(UserModel user) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.emailAddress, password: user.password);
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: user.emailAddress.trim(), password: user.password.trim());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      Utils.showSnackBar("Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    }
  }
}
