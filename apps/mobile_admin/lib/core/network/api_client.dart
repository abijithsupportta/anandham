import 'package:dio/dio.dart';
import 'package:anandham_admin/core/constants/api_constants.dart';
import 'package:anandham_admin/core/errors/exceptions.dart';

/// API client wrapper around Dio for making HTTP requests.
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.contentType,
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  /// Sets the authorization token for subsequent requests.
  void setAuthToken(String token) {
    _dio.options.headers[ApiConstants.authorization] =
        '${ApiConstants.bearer} $token';
  }

  /// Removes the authorization token.
  void clearAuthToken() {
    _dio.options.headers.remove(ApiConstants.authorization);
  }

  /// Performs a GET request.
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Performs a POST request.
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Performs a PUT request.
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Performs a DELETE request.
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handles DioException and converts to app-specific exceptions.
  AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      default:
        return ServerException(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }

  /// Handles HTTP response errors based on status code.
  AppException _handleResponseError(Response? response) {
    final statusCode = response?.statusCode ?? 500;
    final message = response?.data?['message'] ?? 'Server error occurred';

    switch (statusCode) {
      case 401:
        return AuthenticationException(message: message);
      case 403:
        return AuthorizationException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        return ValidationException(message: message);
      default:
        return ServerException(message: message, statusCode: statusCode);
    }
  }
}
