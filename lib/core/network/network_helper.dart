import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ez_english/core/network/status_code.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'apis_constants.dart';
import 'custom_response.dart';

class NetworkHelper {
  bool debugging = true;
  Map<String, String> headers = HashMap();
  static final NetworkHelper _instance = NetworkHelper._privateConstructor();

  NetworkHelper._privateConstructor() {
    _initDio();
  }

  void _initDio() async {
    _dio = Dio(baseOptions);
    if (debugging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  late Dio _dio;
  var baseOptions = BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: 60000,
    receiveTimeout: 60000,
    followRedirects: false,
    validateStatus: (status) {
      return status != null ? status < 500 : true;
    },
  );

  static NetworkHelper get instance => _instance;

  void _setJsonHeader() {
    headers.putIfAbsent('Accept', () => 'application/json');
  }

  void _setAuthHeader() {
    headers.putIfAbsent(
        'Ocp-Apim-Subscription-Key', () => '${APIConstants.apiKey}');
  }

  Future<CustomResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    _setJsonHeader();
    _setAuthHeader();
    Response response;

    response = await _dio.get(url,
        queryParameters: queryParameters, options: Options(headers: headers));
    // ignore: prefer_typing_uninitialized_variables
    var data;
    String? errorMessage, successMessage;
    if (response.statusCode == StatusCode.success) {
      data = response.data;
    } else {
      errorMessage = response.data['message'] ?? "Something went wrong";
    }
    return CustomResponse(
      data: data,
      statusCode: response.statusCode,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  Future<CustomResponse> post(
      {required String url,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headersForRequest,
      bool returnBytesResponse = false,
      body,
      formData}) async {
    _setJsonHeader();
    // _setHeaderContentType(contentType: 'application/x-www-form-urlencoded');
    _setAuthHeader();
    Response? response;
    try {
      if (headersForRequest != null) {
        headersForRequest.forEach((key, value) {
          headers.putIfAbsent(key, () => value);
        });
      }
      response = await _dio.post(
        url,
        queryParameters: queryParameters,
        data: formData != null ? (formData) : body,
        options: Options(
          responseType: returnBytesResponse ? ResponseType.bytes : null,
          headers: headers,
        ),
      );
      var data;
      String? errorMessage, successMessage;
      if (response.statusCode == StatusCode.success ||
          response.statusCode == StatusCode.created) {
        data = response.data;
      } else {
        errorMessage = response.data['message'] ?? "Something went wrong";
      }
      return CustomResponse(
        data: data,
        statusCode: response.statusCode,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );
    } catch (e) {
      return CustomResponse(
        statusCode: response?.statusCode,
        errorMessage: "Something Went Wrong",
      );
    }
  }

  Future<CustomResponse> delete({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headersForRequest,
    body,
  }) async {
    // _setJsonHeader();
    _setAuthHeader();
    Response? response;
    try {
      if (headersForRequest != null) {
        headersForRequest.forEach((key, value) {
          headers.putIfAbsent(key, () => value);
        });
      }
      response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: body != null ? json.encode(body) : null,
        options: Options(
          headers: headers,
        ),
      );
      var data;
      String? errorMessage, successMessage;
      if (response.statusCode == StatusCode.success ||
          response.statusCode == StatusCode.created) {
        data = response.data;
      } else {
        errorMessage = response.data['message'] ?? "Something went wrong";
      }
      return CustomResponse(
        data: data,
        statusCode: response.statusCode,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );
    } catch (e) {
      return CustomResponse(
        statusCode: response?.statusCode,
        errorMessage: "Something Went Wrong",
      );
    }
  }

  Future<CustomResponse> put(
      {required String url,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headersForRequest,
      body,
      formData}) async {
    _setAuthHeader();
    Response? response;
    try {
      if (headersForRequest != null) {
        headersForRequest.forEach((key, value) {
          headers.putIfAbsent(key, () => value);
        });
      }
      response = await _dio.put(
        url,
        queryParameters: queryParameters,
        data: formData != null ? (formData) : body,
        options: Options(
          headers: headers,
        ),
      );
      var data;
      String? errorMessage, successMessage;
      if (response.statusCode == StatusCode.success ||
          response.statusCode == StatusCode.created ||
          response.statusCode == StatusCode.updated) {
        data = response.data;
      } else {
        errorMessage = response.data['message'] ?? "Something went wrong";
      }
      return CustomResponse(
        data: data,
        statusCode: response.statusCode,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );
    } catch (e) {
      return CustomResponse(
        statusCode: response?.statusCode,
        errorMessage: "Something Went Wrong",
      );
    }
  }
}
