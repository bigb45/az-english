class StatusCode {
  static const int success = 200;
  static const int created = 201;
  static const int updated = 204;

  static const int unauthorizedError = 401;
  static const int validationError = 422;
  static const int actionForbidden = 403;
  static const int invalidTokenError = 400;
  static const int notFound = 404;
  static const int serverError = 500;
}

enum ErrorType {
  noNetworkError,
  noDataError,
  generalError,
  unauthorizedError,
  actionNotPerformed,
  actionForbidden
}
