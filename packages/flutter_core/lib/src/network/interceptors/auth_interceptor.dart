import 'package:dio/dio.dart';

/// Injects the Bearer token into every outgoing request and handles 401s.
class AuthInterceptor extends Interceptor {
  /// Async callback that returns the current access token (or `null`).
  final Future<String?> Function() tokenProvider;

  /// Called when a 401 response is received so the host app can navigate to
  /// login or trigger a token-refresh flow.
  final void Function()? onTokenExpired;

  const AuthInterceptor({required this.tokenProvider, this.onTokenExpired});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onTokenExpired?.call();
    }
    handler.next(err);
  }
}
