import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A thin wrapper around [SharedPreferences] providing typed get/set helpers.
class StorageService {
  SharedPreferences? _prefs;

  /// Must be called once (usually at app start) before any other method.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    assert(_prefs != null, 'StorageService.init() must be called first.');
    return _prefs!;
  }

  // ── String ─────────────────────────────────────────────────────────────

  Future<bool> setString(String key, String value) =>
      _preferences.setString(key, value);

  String? getString(String key) => _preferences.getString(key);

  // ── Bool ───────────────────────────────────────────────────────────────

  Future<bool> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  bool? getBool(String key) => _preferences.getBool(key);

  // ── Int ────────────────────────────────────────────────────────────────

  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  int? getInt(String key) => _preferences.getInt(key);

  // ── Double ─────────────────────────────────────────────────────────────

  Future<bool> setDouble(String key, double value) =>
      _preferences.setDouble(key, value);

  double? getDouble(String key) => _preferences.getDouble(key);

  // ── JSON objects ───────────────────────────────────────────────────────

  Future<bool> setJson(String key, Map<String, dynamic> value) =>
      _preferences.setString(key, jsonEncode(value));

  Map<String, dynamic>? getJson(String key) {
    final raw = _preferences.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // ── String lists ───────────────────────────────────────────────────────

  Future<bool> setStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);

  List<String>? getStringList(String key) => _preferences.getStringList(key);

  // ── Utilities ──────────────────────────────────────────────────────────

  /// Returns `true` if a value is stored for [key].
  bool containsKey(String key) => _preferences.containsKey(key);

  /// Removes the value stored for [key].
  Future<bool> remove(String key) => _preferences.remove(key);

  /// Removes all stored values.
  Future<bool> clear() => _preferences.clear();
}
