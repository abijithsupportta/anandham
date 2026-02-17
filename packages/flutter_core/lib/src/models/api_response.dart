/// Generic wrapper for all API responses.
///
/// ```dart
/// final response = ApiResponse<UserModel>.fromJson(
///   json,
///   (data) => UserModel.fromJson(data as Map<String, dynamic>),
/// );
/// ```
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  /// Creates an [ApiResponse] from raw JSON.
  ///
  /// [fromJsonT] converts the `data` field to the desired type [T].
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      errors: json['errors'] as Map<String, dynamic>?,
      statusCode: json['status_code'] as int?,
    );
  }

  /// Convenience factory for a successful response.
  factory ApiResponse.success({T? data, String? message}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: 200,
    );
  }

  /// Convenience factory for a failed response.
  factory ApiResponse.failure({
    String? message,
    Map<String, dynamic>? errors,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  /// Converts the response back to JSON.
  Map<String, dynamic> toJson(Object? Function(T value)? toJsonT) {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': toJsonT != null ? toJsonT(data as T) : data,
      if (errors != null) 'errors': errors,
      if (statusCode != null) 'status_code': statusCode,
    };
  }

  @override
  String toString() =>
      'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
}
