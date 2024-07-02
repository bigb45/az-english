class CustomResponse {
  final dynamic data;
  final int? statusCode;
  final String? successMessage;
  final String? errorMessage;

  CustomResponse(
      {this.statusCode, this.successMessage, this.errorMessage, this.data});
}
