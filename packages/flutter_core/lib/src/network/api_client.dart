import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'api_exceptions.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// A Dio-based HTTP client preconfigured for the Anandham API.
///
/// Usage:
/// ```dart
/// final client = ApiClient(
///   baseUrl: ApiConstants.productionBaseUrl,
///   tokenProvider: () async => myStorageService.getToken(),
/// );
///
/// final response = await client.get('/users/me');
/// ```
class ApiClient {
  late final Dio _dio;

  /// Creates an [ApiClient].
  ///
  /// * [baseUrl] – defaults to [ApiConstants.productionBaseUrl].
  /// * [tokenProvider] – async callback that returns the current access token.
  /// * [onTokenExpired] – called when a 401 is received so the host app can
  ///   trigger a re-auth flow.
  /// * [enableLogging] – adds a logging interceptor (default `true` in debug).
  ApiClient({
    String? baseUrl,
    Future<String?> Function()? tokenProvider,
    void Function()? onTokenExpired,
    bool enableLogging = true,
    List<Interceptor> extraInterceptors = const [],
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.productionBaseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.acceptHeader,
        },
        responseType: ResponseType.json,
      ),
    );

    // Order matters: auth first, then extras, then logging last.
    if (tokenProvider != null) {
      _dio.interceptors.add(
        AuthInterceptor(
          tokenProvider: tokenProvider,
          onTokenExpired: onTokenExpired,
        ),
      );
    }

    _dio.interceptors.addAll(extraInterceptors);

    if (enableLogging) {
      _dio.interceptors.add(const LoggingInterceptor());
    }
  }

  /// Provides direct access to the underlying [Dio] instance for advanced use.
  Dio get dio => _dio;

  // ── HTTP verbs ───────────────────────────────────────────────────────────

  /// Sends a GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Sends a POST request.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Sends a PUT request.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Sends a PATCH request.
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Sends a DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Uploads a file using multipart form data.
  Future<Response<T>> upload<T>(
    String path, {
    required FormData formData,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    return _execute(
      () => _dio.post<T>(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      ),
    );
  }

  // ── Error mapping ───────────────────────────────────────────────────────

  /// Wraps every request to map [DioException] into typed [ApiException]s.
  Future<Response<T>> _execute<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Converts a [DioException] to a domain-specific [ApiException].
  ApiException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(originalError: e);

      case DioExceptionType.connectionError:
        return NoInternetException(originalError: e);

      case DioExceptionType.badResponse:
        return _mapStatusCode(e);

      case DioExceptionType.cancel:
        return const UnknownApiException(message: 'Request was cancelled');

      default:
        return UnknownApiException(
          message: e.message ?? 'An unexpected error occurred',
          originalError: e,
        );
    }
  }

  ApiException _mapStatusCode(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final message = data is Map<String, dynamic>
        ? data['message'] as String?
        : null;
    final errors = data is Map<String, dynamic>
        ? data['errors'] as Map<String, dynamic>?
        : null;

    return switch (statusCode) {
      400 => BadRequestException(
        message: message ?? 'Bad request',
        originalError: e,
        validationErrors: errors,
      ),
      401 => UnauthorizedException(
        message: message ?? 'Unauthorized',
        originalError: e,
      ),
      403 => ForbiddenException(
        message: message ?? 'Forbidden',
        originalError: e,
      ),
      404 => NotFoundException(
        message: message ?? 'Not found',
        originalError: e,
      ),
      409 => ConflictException(
        message: message ?? 'Conflict',
        originalError: e,
      ),
      422 => UnprocessableEntityException(
        message: message ?? 'Validation failed',
        originalError: e,
        validationErrors: errors,
      ),
      429 => TooManyRequestsException(
        message: message ?? 'Too many requests',
        originalError: e,
      ),
      _ when statusCode != null && statusCode >= 500 => ServerException(
        message: message ?? 'Server error',
        statusCode: statusCode,
        originalError: e,
      ),
      _ => UnknownApiException(
        message: message ?? 'Unexpected error',
        statusCode: statusCode,
        originalError: e,
      ),
    };
  }
}
