import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Logs request/response details using `dart:developer` (visible in DevTools).
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('──▶ REQUEST ────────────────────────────────────────')
      ..writeln('${options.method.toUpperCase()} ${options.uri}')
      ..writeln('Headers: ${options.headers}');

    if (options.data != null) {
      buffer.writeln('Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('Query: ${options.queryParameters}');
    }

    developer.log(buffer.toString(), name: 'ApiClient');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('◀── RESPONSE ───────────────────────────────────────')
      ..writeln(
        '${response.statusCode} ${response.requestOptions.method.toUpperCase()} '
        '${response.requestOptions.uri}',
      )
      ..writeln('Data: ${response.data}');

    developer.log(buffer.toString(), name: 'ApiClient');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('◀── ERROR ──────────────────────────────────────────')
      ..writeln(
        '${err.response?.statusCode ?? 'N/A'} ${err.requestOptions.method.toUpperCase()} '
        '${err.requestOptions.uri}',
      )
      ..writeln('Message: ${err.message}');

    if (err.response?.data != null) {
      buffer.writeln('Response: ${err.response?.data}');
    }

    developer.log(buffer.toString(), name: 'ApiClient');
    handler.next(err);
  }
}
