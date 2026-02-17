import 'package:anandham_admin/core/network/api_client.dart';

/// Abstract interface for remote API operations.
abstract class RemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> getDashboard();

  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 20});

  Future<Map<String, dynamic>> getAnalytics();

  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  Future<void> logout();
}

/// Implementation of [RemoteDataSource] using ApiClient.
class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiClient _apiClient;

  RemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/admin/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiClient.get('/admin/dashboard');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '/admin/users',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getAnalytics() async {
    final response = await _apiClient.get('/admin/analytics');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await _apiClient.post('/auth/logout');
  }
}
