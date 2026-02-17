import 'package:shared_preferences/shared_preferences.dart';

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
  final SharedPreferences _sharedPreferences;

  static const String _tokenKey = 'auth_token';

  LocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheToken(String token) async {
    await _sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> removeToken() async {
    await _sharedPreferences.remove(_tokenKey);
  }

  @override
  Future<void> cacheData(String key, String data) async {
    await _sharedPreferences.setString(key, data);
  }

  @override
  Future<String?> getCachedData(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> removeCachedData(String key) async {
    await _sharedPreferences.remove(key);
  }

  @override
  Future<void> clearAll() async {
    await _sharedPreferences.clear();
  }
}
