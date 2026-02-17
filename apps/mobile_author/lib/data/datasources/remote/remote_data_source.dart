import 'package:anandham_author/core/network/api_client.dart';

/// Abstract interface for remote API operations.
abstract class RemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> getProfile();

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);

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
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.get('/author/profile');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put('/author/profile', data: data);
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
