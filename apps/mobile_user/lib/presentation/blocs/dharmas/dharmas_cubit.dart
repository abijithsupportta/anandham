import 'dart:async';

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
      emit(
        state.copyWith(isLoading: false, items: localItems, errorMessage: null),
      );

      if (hasCached || localItems.isNotEmpty) {
        unawaited(_syncInBackground());
      }
    } catch (_) {
      final localItems = await _localRepository.getDharmas();
      emit(
        state.copyWith(
          isLoading: false,
          items: localItems,
          errorMessage: localItems.isEmpty ? 'Failed to load dharmas' : null,
        ),
      );
    }
  }

  Future<void> _syncInBackground() async {
    try {
      await _syncService.syncDharmas();
      final refreshedItems = await _localRepository.getDharmas();
      emit(
        state.copyWith(
          isLoading: false,
          items: refreshedItems,
          errorMessage: null,
        ),
      );
    } catch (_) {}
  }
}
