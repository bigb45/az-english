class CustomException implements Exception {
  final FirebaseExceptionType type;
  final String message;

  CustomException({required this.message, required this.type});
}

enum FirebaseExceptionType { networkError, serverError, unknownError }
