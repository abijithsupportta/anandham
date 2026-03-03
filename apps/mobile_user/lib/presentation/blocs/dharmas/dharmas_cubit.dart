import 'dart:async';

import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/data/repositories/local_content_repository.dart';
import 'package:anandham_user/data/services/content_sync_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dharmas_state.dart';

class DharmasCubit extends Cubit<DharmasState> {
  final LocalContentRepository _localRepository;
  final ContentSyncService _syncService;

  DharmasCubit({
    LocalContentRepository? localRepository,
    ContentSyncService? syncService,
  }) : _localRepository = localRepository ?? sl<LocalContentRepository>(),
       _syncService = syncService ?? sl<ContentSyncService>(),
       super(const DharmasState.initial());

  Future<void> loadDharmas() async {
    emit(state.copyWith(isLoading: state.items.isEmpty, errorMessage: null));

    try {
      final hasCached = state.items.isNotEmpty;
      if (!hasCached) {
        try {
          await _syncService.syncDharmas();
        } catch (_) {}
      }

      final localItems = await _localRepository.getDharmas();
      final categoryById = await _fetchCategoryNames(localItems);
      emit(
        state.copyWith(
          isLoading: false,
          items: localItems,
          categoryById: categoryById,
          errorMessage: null,
        ),
      );

      if (hasCached || localItems.isNotEmpty) {
        unawaited(_syncInBackground());
      }
    } catch (_) {
      final localItems = await _localRepository.getDharmas();
      final categoryById = await _fetchCategoryNames(localItems);
      emit(
        state.copyWith(
          isLoading: false,
          items: localItems,
          categoryById: categoryById,
          errorMessage: localItems.isEmpty ? 'Failed to load dharmas' : null,
        ),
      );
    }
  }

  Future<void> _syncInBackground() async {
    try {
      await _syncService.syncDharmas();
      final refreshedItems = await _localRepository.getDharmas();
      final categoryById = await _fetchCategoryNames(refreshedItems);
      emit(
        state.copyWith(
          isLoading: false,
          items: refreshedItems,
          categoryById: categoryById,
          errorMessage: null,
        ),
      );
    } catch (_) {}
  }

  Future<Map<String, String>> _fetchCategoryNames(
    List<DharmaItemView> items,
  ) async {
    if (items.isEmpty) {
      return const {};
    }

    try {
      final ids = items.map((item) => item.id).toList();
      final rows = await SupabaseConfig.client
          .from('dharmas')
          .select('id, category:content_categories(name)')
          .inFilter('id', ids);

      final map = <String, String>{};
      for (final row in (rows as List<dynamic>).cast<Map<String, dynamic>>()) {
        final id = row['id'] as String?;
        final categoryObj = row['category'];
        final categoryName = categoryObj is Map<String, dynamic>
            ? (categoryObj['name'] as String?)
            : null;
        if (id != null &&
            categoryName != null &&
            categoryName.trim().isNotEmpty) {
          map[id] = categoryName.trim();
        }
      }

      return map;
    } catch (_) {
      return const {};
    }
  }
}
