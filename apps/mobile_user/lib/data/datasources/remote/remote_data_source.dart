import 'package:anandham_user/core/network/api_client.dart';

/// Abstract interface for remote API operations.
abstract class RemoteDataSource {
  /// Authenticates user with email and password.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  /// Registers a new user.
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Fetches the current user's profile.
  Future<Map<String, dynamic>> getProfile();

  /// Updates the current user's profile.
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);

  /// Refreshes the authentication token.
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  /// Logs out the current user.
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
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.get('/user/profile');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put('/user/profile', data: data);
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
