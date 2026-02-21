import 'dart:convert';

import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/domain/repositories/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepositoryImpl implements HomeRepository {
  static const String _contentTypesCacheKey = 'home_content_types_cache';
  static const String _profileNameCacheKey = 'home_profile_name_cache';

  @override
  Future<String?> getProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedName = prefs.getString(_profileNameCacheKey);
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return cachedName;
    }

    try {
      final List<dynamic> rows = await SupabaseConfig.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .limit(1);

      if (rows.isEmpty) {
        return cachedName;
      }

      final name = (rows.first as Map<String, dynamic>)['full_name'] as String?;
      final trimmedName = name?.trim();
      if (trimmedName == null || trimmedName.isEmpty) {
        return cachedName;
      }

      await prefs.setString(_profileNameCacheKey, trimmedName);
      return trimmedName;
    } catch (_) {
      return cachedName;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getContentTypes() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final rows = await SupabaseConfig.client
          .from('content_types')
          .select(
            'name, display_name, description, icon, color, table_name, display_order, is_active',
          )
          .eq('is_active', true)
          .order('display_order', ascending: true);

      final list = (rows as List<dynamic>);
      await prefs.setString(_contentTypesCacheKey, jsonEncode(list));

      return list
          .map((raw) => Map<String, dynamic>.from(raw as Map<String, dynamic>))
          .toList();
    } catch (_) {
      final cached = prefs.getString(_contentTypesCacheKey);
      if (cached == null || cached.trim().isEmpty) {
        return const [];
      }

      try {
        final decoded = jsonDecode(cached) as List<dynamic>;
        return decoded
            .map(
              (raw) => Map<String, dynamic>.from(raw as Map<String, dynamic>),
            )
            .toList();
      } catch (_) {
        return const [];
      }
    }
  }
}
