import 'package:firebase_auth/firebase_auth.dart';

class CustomException implements Exception {
  // final FirebaseExceptionType type;
  final String message;

  CustomException(this.message);

  factory CustomException.fromFirebaseAuthException(FirebaseAuthException e) {
    return CustomException(_mapFirebaseAuthExceptionCode(e.code));
  }

  static String _mapFirebaseAuthExceptionCode(String code) {
    switch (code) {
      // FirebaseAuth
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'The user account has been disabled by an administrator.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'The password is invalid.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      // TODO Will always get this error unless we turn off email enumeration protection
      case "invalid-credential":
        return "Please check your email, and password and try again";
      default:
        return 'An undefined error occurred.';
    }
  }

  factory CustomException.fromFirebaseFirestoreException(FirebaseException e) {
    return CustomException(_mapFirestoreExceptionMessage(e.code));
  }
  static String _mapFirestoreExceptionMessage(String code) {
    switch (code) {
      case 'permission-denied':
        return 'Permission denied. Please check your access permissions.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      default:
        return 'An undefined error occurred.';
    }
  }
}

// TODO Do i need to use this enum ?
enum FirebaseExceptionType { networkError, serverError, unknownError }
