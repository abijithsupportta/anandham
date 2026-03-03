import 'dart:convert';

import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial());

  static const String _contentTypesCacheKey = 'home_content_types_cache';
  static const String _profileNameCacheKey = 'home_profile_name_cache';

  Future<void> loadInitial() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final results = await Future.wait([
        _loadContentTypes(),
        _loadProfileName(),
      ]);

      final loadedContentTypes = results[0] as List<HomeContentTypeItem>;
      final loadedProfileName = results[1] as String?;

      emit(
        state.copyWith(
          isLoading: false,
          contentTypes: loadedContentTypes,
          profileName: loadedProfileName,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load home content',
        ),
      );
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<String?> _loadProfileName() async {
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

  Future<List<HomeContentTypeItem>> _loadContentTypes() async {
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

      return _prepareVisibleContentTypes(
        list
            .map(
              (raw) => HomeContentTypeItem.fromMap(raw as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (_) {
      final cached = prefs.getString(_contentTypesCacheKey);
      if (cached == null || cached.trim().isEmpty) {
        return const [];
      }

      try {
        final decoded = jsonDecode(cached) as List<dynamic>;
        return _prepareVisibleContentTypes(
          decoded
              .map(
                (raw) =>
                    HomeContentTypeItem.fromMap(raw as Map<String, dynamic>),
              )
              .toList(),
        );
      } catch (_) {
        return const [];
      }
    }
  }

  List<HomeContentTypeItem> _prepareVisibleContentTypes(
    List<HomeContentTypeItem> all,
  ) {
    final filtered = all.where((item) => item.name != 'blogs').toList();
    filtered.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return filtered;
  }
}
