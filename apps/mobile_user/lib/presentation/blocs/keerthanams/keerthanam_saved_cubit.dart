import 'dart:async';

import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/data/repositories/local_content_repository.dart';
import 'package:anandham_user/data/services/content_sync_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'keerthanam_saved_state.dart';

class KeerthanamSavedCubit extends Cubit<KeerthanamSavedState> {
  static const String _contentType = 'keerthanam';
  final LocalContentRepository _localRepository;
  final ContentSyncService _syncService;

  KeerthanamSavedCubit({
    LocalContentRepository? localRepository,
    ContentSyncService? syncService,
  }) : _localRepository = localRepository ?? sl<LocalContentRepository>(),
       _syncService = syncService ?? sl<ContentSyncService>(),
       super(const KeerthanamSavedState.initial());

  Future<void> loadSaved({bool forceSync = false}) async {
    emit(state.copyWith(isLoading: state.items.isEmpty, errorMessage: null));

    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, items: [], savedIds: {}));
        return;
      }

      final localIds = await _localRepository.getSavedContentIds(
        userId: user.id,
        contentType: _contentType,
      );
      final localItems = await _localRepository.getKeerthanamsByIds(localIds);

      emit(
        state.copyWith(
          isLoading: false,
          items: localItems,
          savedIds: localIds.toSet(),
          errorMessage: null,
        ),
      );

      if (forceSync || localIds.isEmpty) {
        await _syncService.syncSavedItemsForUser(
          userId: user.id,
          contentType: _contentType,
          force: true,
        );
        final refreshedIds = await _localRepository.getSavedContentIds(
          userId: user.id,
          contentType: _contentType,
        );
        var refreshedItems = await _localRepository.getKeerthanamsByIds(
          refreshedIds,
        );
        if (refreshedItems.isEmpty && refreshedIds.isNotEmpty) {
          await _syncService.syncKeerthanams(force: true);
          refreshedItems = await _localRepository.getKeerthanamsByIds(
            refreshedIds,
          );
        }
        emit(
          state.copyWith(
            isLoading: false,
            items: refreshedItems,
            savedIds: refreshedIds.toSet(),
            errorMessage: null,
          ),
        );
      } else {
        unawaited(_syncInBackground(user.id));
      }
    } catch (_) {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, items: [], savedIds: {}));
        return;
      }

      final localIds = await _localRepository.getSavedContentIds(
        userId: user.id,
        contentType: _contentType,
      );
      var localItems = await _localRepository.getKeerthanamsByIds(localIds);
      if (localItems.isEmpty && localIds.isNotEmpty) {
        await _syncService.syncKeerthanams(force: true);
        localItems = await _localRepository.getKeerthanamsByIds(localIds);
      }
      emit(
        state.copyWith(
          isLoading: false,
          items: localItems,
          savedIds: localIds.toSet(),
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> _syncInBackground(String userId) async {
    try {
      await _syncService.syncSavedItemsForUser(
        userId: userId,
        contentType: _contentType,
      );
      final refreshedIds = await _localRepository.getSavedContentIds(
        userId: userId,
        contentType: _contentType,
      );
      var refreshedItems = await _localRepository.getKeerthanamsByIds(
        refreshedIds,
      );
      if (refreshedItems.isEmpty && refreshedIds.isNotEmpty) {
        await _syncService.syncKeerthanams(force: true);
        refreshedItems = await _localRepository.getKeerthanamsByIds(
          refreshedIds,
        );
      }
      emit(
        state.copyWith(
          isLoading: false,
          items: refreshedItems,
          savedIds: refreshedIds.toSet(),
          errorMessage: null,
        ),
      );
    } catch (_) {}
  }

  Future<void> removeSaved(String keerthanamId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    await _localRepository.removeSavedItem(
      userId: user.id,
      contentType: _contentType,
      contentId: keerthanamId,
    );
    await _syncService.enqueuePendingOp(
      tableRef: 'saved_items',
      opType: 'delete',
      payload: {
        'user_id': user.id,
        'content_type': _contentType,
        'content_id': keerthanamId,
      },
    );

    await loadSaved();
  }

  Future<void> toggleSaved(String keerthanamId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    if (state.savedIds.contains(keerthanamId)) {
      await removeSaved(keerthanamId);
      return;
    }

    final nextPosition =
        (await _localRepository.getMaxSavedPosition(
          userId: user.id,
          contentType: _contentType,
        )) ??
        0;

    await _localRepository.upsertSavedItem(
      userId: user.id,
      contentType: _contentType,
      contentId: keerthanamId,
      position: nextPosition + 1,
    );
    await _syncService.enqueuePendingOp(
      tableRef: 'saved_items',
      opType: 'upsert',
      payload: {
        'user_id': user.id,
        'content_type': _contentType,
        'content_id': keerthanamId,
        'position': nextPosition + 1,
      },
    );

    await loadSaved();
  }

  Future<void> reorderSaved(int oldIndex, int newIndex) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    final current = List<Map<String, dynamic>>.from(state.items);
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final moved = current.removeAt(oldIndex);
    current.insert(newIndex, moved);

    final previousPositions = <String, int>{};
    for (var i = 0; i < state.items.length; i++) {
      final id = state.items[i]['id'] as String?;
      if (id != null) {
        previousPositions[id] = i + 1;
      }
    }

    for (var i = 0; i < current.length; i++) {
      final id = current[i]['id'] as String?;
      if (id == null) {
        continue;
      }
      final newPosition = i + 1;
      if (previousPositions[id] == newPosition) {
        continue;
      }

      await _localRepository.updateSavedPosition(
        userId: user.id,
        contentType: _contentType,
        contentId: id,
        position: newPosition,
      );
      await _syncService.enqueuePendingOp(
        tableRef: 'saved_items',
        opType: 'upsert',
        payload: {
          'user_id': user.id,
          'content_type': _contentType,
          'content_id': id,
          'position': newPosition,
        },
      );
    }

    emit(
      state.copyWith(
        items: current,
        savedIds: current
            .map((item) => item['id'] as String?)
            .whereType<String>()
            .toSet(),
      ),
    );
  }
}
