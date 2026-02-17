import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstract interface for local data operations.
abstract class LocalDataSource {
  /// Caches the authentication token.
  Future<void> cacheToken(String token);

  /// Retrieves the cached authentication token.
  Future<String?> getToken();

  /// Removes the cached authentication token.
  Future<void> removeToken();

  /// Caches data with a given key.
  Future<void> cacheData(String key, String data);

  /// Retrieves cached data by key.
  Future<String?> getCachedData(String key);

  /// Removes cached data by key.
  Future<void> removeCachedData(String key);

  /// Clears all cached data.
  Future<void> clearAll();
}

/// Implementation of [LocalDataSource] using SharedPreferences.
class LocalDataSourceImpl implements LocalDataSource {
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';

  LocalDataSourceImpl({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  @override
  Future<void> cacheToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> removeToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<void> cacheData(String key, String data) async {
    await _secureStorage.write(key: key, value: data);
  }

  @override
  Future<String?> getCachedData(String key) async {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> removeCachedData(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
